defmodule CenWeb.UserJSON do
  alias Cen.Accounts.User

  @spec index(%{users: [User.t()]}) :: %{data: [map()]}
  def index(%{users: users}) do
    %{data: Enum.map(users, &data/1)}
  end

  @spec show(%{user: User.t()}) :: %{data: map()}
  def show(%{user: user}) do
    %{data: data(user)}
  end

  @spec data(User.t()) :: map()
  def data(user) do
    %{
      id: user.id,
      email: user.email,
      fullname: user.fullname,
      role: user.role,
      birth_date: user.birth_date
    }
  end
end
