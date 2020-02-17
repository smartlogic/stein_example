defmodule SteinExample.Repo.Migrations.CreateMfaMethods do
  use Ecto.Migration

  alias SteinExample.Users.MFAMethod.TypeEnum

  def change do
    TypeEnum.create_type()

    create table(:users_mfa_methods) do
      add :user_id, references(:users)

      add :type, TypeEnum.type()
      add :secret, :binary
      add :counter, :integer
      add :active, :boolean

      timestamps()
    end

    create index(:users_mfa_methods, [:user_id, :type], unique: true)
  end
end
