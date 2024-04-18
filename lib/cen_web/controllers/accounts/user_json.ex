defmodule CenWeb.UserJSON do
  alias Cen.Accounts.User

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
      birth_date: user.birth_date,
      phone: user.phone
    }
  end
end
