defmodule Cen.QueryUtils do
  @moduledoc false
  import Ecto.Query, warn: false

  @type operator :: :eq | :in | :intersection | :not_gt | :not_lt | :search | :is_nil

  @spec filter(Ecto.Queryable.t(), term(), operator, term()) :: Ecto.Query.t()
  def filter(query, field_name, operator, value)

  def filter(query, _field_name, _operator, nil), do: query

  def filter(query, field_name, :eq, value) do
    where(query, [record], field(record, ^field_name) == ^value)
  end

  def filter(query, field_name, :in, values) do
    where(query, [record], field(record, ^field_name) in ^values)
  end

  def filter(query, field_name, :intersection, values) do
    where(query, [record], fragment("? && ?", field(record, ^field_name), ^values))
  end

  def filter(query, field_name, :not_lt, value) do
    where(query, [record], field(record, ^field_name) >= ^value or is_nil(field(record, ^field_name)))
  end

  def filter(query, field_name, :not_gt, value) do
    where(query, [record], field(record, ^field_name) <= ^value or is_nil(field(record, ^field_name)))
  end

  def filter(query, field_name, :search, value) do
    from(
      from record in query,
        where:
          fragment(
            "? @@ websearch_to_tsquery('russian', ?)",
            field(record, ^field_name),
            ^value
          ),
        order_by: {
          :desc,
          fragment(
            "ts_rank_cd(?, websearch_to_tsquery('russian', ?))",
            field(record, ^field_name),
            ^value
          )
        }
    )
  end
end
