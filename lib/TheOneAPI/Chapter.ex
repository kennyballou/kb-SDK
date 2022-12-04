defmodule TheOneAPI.Chapter do
  @enforce_keys [:id, :chapterName]
  defstruct [:book, :id, :chapterName]

  @type t :: %TheOneAPI.Chapter{book: String.t(), id: String.t(), chapterName: String.t()}

  def from_json(book_id, chapter) do
    %TheOneAPI.Chapter{book: book_id,
                       id: chapter["_id"],
                       chapterName: chapter["chapterName"]}
  end

  def from_json(chapter) do
    %TheOneAPI.Chapter{book: Map.get(chapter, "book"),
                       id: chapter["_id"],
                       chapterName: chapter["chapterName"]
    }
  end
end
