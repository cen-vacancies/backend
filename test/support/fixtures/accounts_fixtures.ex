# credo:disable-for-this-file Credo.Check.Readability.Specs
defmodule Cen.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cen.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"
  def valid_user_fullname, do: "Иванов Иван Иванович"
  def valid_user_role, do: :applicant
  def valid_user_phone, do: "+78001234567"

  def valid_user_attributes(attrs) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password(),
      fullname: valid_user_fullname(),
      role: valid_user_role(),
      phone: valid_user_phone(),
      birth_date: ~D[2000-01-01]
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Cen.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
