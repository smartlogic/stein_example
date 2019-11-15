defmodule SteinExample.Users do
  @moduledoc """
  Users context
  """

  alias SteinExample.Repo
  alias SteinExample.Users.User
  alias Stein.Accounts

  @doc """
  Changeset for a session
  """
  def new(), do: Ecto.Changeset.change(%User{}, %{})

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
    %User{}
    |> User.create_changeset(params)
    |> Repo.insert()
  end
end
