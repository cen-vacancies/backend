defmodule Cen.QueryUtils do
  @moduledoc false
  import Ecto.Query, warn: false

  @type operator :: :eq | :in | :not_gt | :not_lt

  @spec filter(Ecto.Queryable.t(), term(), operator, term()) :: Ecto.Query.t()
  def filter(query, field_name, operator, value)

  def filter(query, _field_name, _operator, nil), do: query

  def filter(query, field_name, :eq, value) do
    where(query, [record], field(record, ^field_name) == ^value)
  end

  def filter(query, field_name, :in, values) do
    where(query, [record], field(record, ^field_name) in ^values)
  end

  def filter(query, field_name, :not_lt, value) do
    where(query, [record], field(record, ^field_name) >= ^value)
  end

  def filter(query, field_name, :not_gt, value) do
    where(query, [record], field(record, ^field_name) <= ^value)
  end
end
