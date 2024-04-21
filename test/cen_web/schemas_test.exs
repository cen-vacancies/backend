defmodule CenWeb.SchemasTest do
  use ExUnit.Case

  import CenWeb.Validator

  alias CenWeb.Schemas

  api_schemas_and_db_schemas = [
    # API Schema - Ecto Schema - ignored fields
    {Schemas.User, Cen.Accounts.User, ~w[hashed_password confirmed_at inserted_at updated_at]a},
    {Schemas.Organization, Cen.Employers.Organization, ~w[employer_id inserted_at updated_at]a},
    {Schemas.Vacancy, Cen.Employers.Vacancy, ~w[organization_id inserted_at updated_at]a},
    {Schemas.CV, Cen.Applicants.CV, ~w[applicant_id inserted_at updated_at]a}
  ]

  for {api_schema, db_schema, ignored_fields} <- api_schemas_and_db_schemas do
    api_schema_name =
      api_schema
      |> Module.split()
      |> Enum.join(".")

    db_schema_name =
      db_schema
      |> Module.split()
      |> Enum.join(".")

    test "#{api_schema_name} matches #{db_schema_name}" do
      unquote(api_schema)

      api_fields =
        unquote(api_schema).schema()
        |> Map.fetch!(:properties)
        |> Map.keys()

      db_fields = unquote(db_schema).__schema__(:fields) -- unquote(ignored_fields)

      fields_diff = db_fields -- api_fields

      assert fields_diff == []
    end
  end

  with {:ok, modules} <- :application.get_key(:cen, :modules) do
    for module <- modules,
        match?(["CenWeb", "Schemas" | _rest], Module.split(module)),
        :functions |> module.__info__() |> Keyword.has_key?(:schema) do
      ["CenWeb", "Schemas" | shortname_list] = Module.split(module)
      shortname = Enum.join(shortname_list, ".")

      test "#{shortname} example matches schema" do
        module = unquote(module)
        assert_schema module, module.schema().example
      end
    end
  end
end
