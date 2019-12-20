defmodule SteinExample.Users do
  @moduledoc """
  Users context
  """

  alias SteinExample.Emails
  alias SteinExample.Mailer
  alias SteinExample.Repo
  alias SteinExample.Users.User
  alias Stein.Accounts

  @doc """
  Changeset for a session or registration
  """
  def new(), do: Ecto.Changeset.change(%User{}, %{})

  @doc """
  Changeset for updating a user
  """
  def edit(user), do: Ecto.Changeset.change(user, %{})

  @doc """
  Get a user by id
  """
  def get(id) do
    case Repo.get(User, id) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Find an user by the token
  """
  def from_token(token) do
    case Repo.get_by(User, token: token) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Validate the user signing in
  """
  def validate_login(email, password) do
    Accounts.validate_login(Repo, User, email, password)
  end

  @doc """
  Create a new user
  """
  def create(params) do
    changeset = User.create_changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        user
        |> Emails.welcome_email()
        |> Mailer.deliver_later()

        {:ok, user}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Update a user's information
  """
  def update(user, params) do
    changeset = User.update_changeset(user, params)

    case Repo.update(changeset) do
      {:ok, user} ->
        maybe_verify_email_again(user, changeset)
        {:ok, user}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp maybe_verify_email_again(user, changeset) do
    case is_nil(Ecto.Changeset.get_change(changeset, :email)) do
      true ->
        :ok

      false ->
        user
        |> Emails.verify_email()
        |> Mailer.deliver_later()
    end
  end

  @doc """
  Confirm an email address
  """
  def verify_email(token) do
    Accounts.verify_email(Repo, User, token)
  end

  @doc """
  Start to reset a user's password
  """
  def start_password_reset(email) do
    Stein.Accounts.start_password_reset(Repo, User, email, fn user ->
      user
      |> Emails.password_reset()
      |> Mailer.deliver_later()
    end)
  end

  @doc """
  Reset the user's password based on a valid reset token
  """
  def reset_password(token, params) do
    Stein.Accounts.reset_password(Repo, User, token, params)
  end
end
