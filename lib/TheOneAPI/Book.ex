defmodule TheOneAPI.Book do
  @enforce_keys [:id, :name]
  defstruct [:name, :id]

  @type t :: %TheOneAPI.Book{name: String.t(), id: String.t()}

  def from_json(book) do
    %TheOneAPI.Book{id: book["_id"],
                    name: book["name"]}
  end
end
