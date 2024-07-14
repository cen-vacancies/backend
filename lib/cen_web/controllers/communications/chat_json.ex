# credo:disable-for-this-file Credo.Check.Readability.Specs
defmodule CenWeb.ChatJSON do
  @moduledoc false

  alias Cen.Communications.Chat
  alias CenWeb.CVJSON
  alias CenWeb.PageJSON
  alias CenWeb.VacancyJSON

  def index(%{page: %{entries: entries} = page}) do
    %{data: for(entry <- entries, do: data(entry)), page: PageJSON.show(page)}
  end

  def data(%Chat{} = chat) do
    %{
      id: chat.id,
      cv: CVJSON.data(chat.cv),
      vacancy: VacancyJSON.data(chat.vacancy)
    }
  end

  def show_message(%{message: message}) do
    %{
      id: message.id,
      author_id: message.author_id,
      text: message.text,
      created_at: message.inserted_at
    }
  end
end
