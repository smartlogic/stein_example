defmodule SteinExample.Users.MFAMethod do
  @moduledoc """
  Handle Multi-factor authentication methods for users
  """

  use Ecto.Schema

  import Ecto.Changeset
  import EctoEnum
  defenum(TypeEnum, :mfa_methods, [:hotp, :totp])

  @type t :: %__MODULE__{}

  schema "users_mfa_methods" do
    field :type, TypeEnum
    field :secret, :binary
    field :counter, :integer, default: 0
    field :active, :boolean, deafult: false

    belongs_to :user, SteinExample.Users.User

    timestamps()
  end

  def activate_changeset(struct) do
    struct
    |> change(active: true)
  end
end
