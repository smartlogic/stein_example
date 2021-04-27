defmodule SteinExample.Seeds do
  @moduledoc """
  Module to help generate seeds

  Functions in here should generally find an existing record that matches
  the params being sent in (based on unique data, a user's name, the name
  of an activation) and update, or if not found create the record. This will
  allow seeds to be run more than once.

  Below is a good starting point for most functions.

  - A default params list that gets merged into the passed in params.
  - A check for an existing record
  - Then insert or update as appropriate

      def create_model(params) do
        default_params = %{
          first_name: "John",
          last_name: "Smith",
        }

        params = Map.merge(default_params, params)

        case Repo.get_by(Models.Model, email: params[:email]) do
          nil ->
            Models.create(params)

          model ->
            Models.update(model, params)
        end
      end
  """

  alias SteinExample.Users
  alias SteinExample.Repo

  def create_user(params) do
    default_params = %{
      first_name: "John",
      last_name: "Smith",
      password: "password",
      password_confirmation: "password"
    }

    params = Map.merge(default_params, params)

    case Repo.get_by(Users.User, email: params[:email]) do
      nil ->
        Users.create(params)

      user ->
        Users.update(user, params)
    end
  end

  # TODO: Alias for above, please implement with roles
  # as required for the specific project
  def create_admin(params), do: create_user(params)
end

{:ok, _user} =
  SteinExample.Seeds.create_admin(%{
    first_name: "Jonathan",
    email: "admin@example.com"
  })

{:ok, _user} =
  SteinExample.Seeds.create_user(%{
    first_name: "Jane",
    email: "jane@example.com"
  })
