defmodule Cen.Enums do
  @moduledoc false

  @spec user_roles() :: [atom(), ...]
  def user_roles, do: ~w[admin applicant employer]a

  @spec employment_types() :: [atom(), ...]
  def employment_types, do: ~w[main secondary practice internship]a

  @spec work_schedules() :: [atom(), ...]
  def work_schedules, do: ~w[full_time part_time remote_working hybrid_working flexible_schedule]a

  @doc """
  Educations enum.

  This is a comparable enumeration, the entities are arranged in ascending order.
  """
  @spec educations() :: [atom(), ...]
  def educations, do: ~w[none secondary secondary_vocational bachelor master doctor]a

  @spec cv_educations() :: [atom(), ...]
  def cv_educations, do: educations() -- [:none]

  @spec field_of_arts() :: [atom(), ...]
  def field_of_arts, do: ~w[music visual performing choreography folklore other]a

  @spec interest_directions() :: [atom(), ...]
  def interest_directions, do: ~w[employer applicant]a
end
