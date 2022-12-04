defmodule TheOneAPI do
  @moduledoc """
  Straightforward library for the ONE API to rule them all.

  This modules uses [Tesla](https://hex.pm/packages/tesla), which provides a
  nice construction of methods for consumable API endpoints.
  """

  use Tesla
  require Logger

  plug Tesla.Middleware.BaseUrl, "https://the-one-api.dev/v2"
  plug Tesla.Middleware.Headers, [{"authorization", "Bearer " <> System.get_env("ONE_API_TOKEN", "")}]
  plug Tesla.Middleware.JSON

  @doc ~S"""
  Return a list of books.

  ## Examples

      iex> TheOneAPI.books(limit: 3)
      [%TheOneAPI.Book{id: "5cf5805fb53e011a64671582", name: "The Fellowship Of The Ring"},
       %TheOneAPI.Book{name: "The Two Towers", id: "5cf58077b53e011a64671583"},
       %TheOneAPI.Book{name: "The Return Of The King", id: "5cf58080b53e011a64671584"}]
  """
  def books(params \\ []) do
    "/book"
    |> get(query: params)
    |> case do
         {:ok, %Tesla.Env{body: %{"docs" => books = [_ | _]}}} ->
           books
           |> Enum.map(&TheOneAPI.Book.from_json/1)
         {:ok, _} ->
           []
         _ ->
           Logger.error(fn _ -> "Error while retrieving books" end)
           []
       end
  end

  @doc ~S"""
  Return a specific book by ID.

  ## Examples

      iex> TheOneAPI.book("5cf5805fb53e011a64671582")
      [%TheOneAPI.Book{id: "5cf5805fb53e011a64671582", name: "The Fellowship Of The Ring"}]
  """
  def book(id, params \\ []) do
    "/book/#{id}"
    |> get(query: params)
    |> case do
         {:ok, %Tesla.Env{body: %{"docs" => book = [_]}}} ->
           book
           |> Enum.map(&TheOneAPI.Book.from_json/1)
         _ ->
           Logger.error(fn -> "Error while retrieving book/#{id}" end)
           []
       end
  end

  @doc ~S"""
  Return all chapters for a specific book by ID.

  ## Examples

      iex> TheOneAPI.book_chapters("5cf5805fb53e011a64671582", limit: 1)
      [%TheOneAPI.Chapter{book: "5cf5805fb53e011a64671582", chapterName: "A Long-expected Party", id: "6091b6d6d58360f988133b8b"}]
  """
  def book_chapters(id, params \\ []) do
    "/book/#{id}/chapter"
    |> get(query: params)
    |> case do
         {:ok, %Tesla.Env{body: %{"docs" => chapters = [_|_]}}} ->
           chapters
           |> Enum.map(fn chapter -> TheOneAPI.Chapter.from_json(id, chapter) end)
         {:ok, _} ->
           []
         _ ->
           Logger.error(fn -> "Error while retrieving chapters" end)
           []
       end
  end

  @doc ~S"""
  Return a list of all movies.

  ## Examples

      iex> TheOneAPI.movies(limit: 3)
      [%TheOneAPI.Movie{
         id: "5cd95395de30eff6ebccde56",
         name: "The Lord of the Rings Series",
         academyAwardNominations: 30,
         academyAwardWins: 17,
         boxOfficeRevenueInMillions: 2917,
         budgetInMillions: 281,
         rottenTomatoesScore: 94,
         runtimeInMinutes: 558},
       %TheOneAPI.Movie{
         id: "5cd95395de30eff6ebccde57",
         name: "The Hobbit Series",
         academyAwardNominations: 7,
         academyAwardWins: 1,
         boxOfficeRevenueInMillions: 2932,
         budgetInMillions: 675,
         rottenTomatoesScore: 66.33333333,
         runtimeInMinutes: 462},
       %TheOneAPI.Movie{
         id: "5cd95395de30eff6ebccde58",
         name: "The Unexpected Journey",
         academyAwardNominations: 3,
         academyAwardWins: 1,
         boxOfficeRevenueInMillions: 1021,
         budgetInMillions: 200,
         rottenTomatoesScore: 64,
         runtimeInMinutes: 169}]
  """
  def movies(params \\ []) do
    "/movie"
    |> get(query: params)
    |> case do
         {:ok, %Tesla.Env{body: %{"docs" => movies = [_|_]}}} ->
           movies
           |> Enum.map(&TheOneAPI.Movie.from_json/1)
         {:ok, _} ->
           []
         _ ->
           Logger.error(fn _ -> "Error while retrieving movives" end)
       end
  end

  @doc ~S"""
  Return a specific movie by ID.

  ## Examples

      iex> TheOneAPI.movie("5cd95395de30eff6ebccde56")
      [%TheOneAPI.Movie{
         id: "5cd95395de30eff6ebccde56",
         name: "The Lord of the Rings Series",
         academyAwardNominations: 30,
         academyAwardWins: 17,
         boxOfficeRevenueInMillions: 2917,
         budgetInMillions: 281,
         rottenTomatoesScore: 94,
         runtimeInMinutes: 558}]
  """
  def movie(id, params \\ []) do
    "/movie/#{id}"
    |> get(query: params)
    |> case do
         {:ok, %Tesla.Env{body: %{"docs" => movies = [_]}}} ->
           movies
           |> Enum.map(&TheOneAPI.Movie.from_json/1)
         {:ok, _} ->
           Logger.warn(fn _ -> "Non-unique movie ID lookup" end)
           []
         _ ->
           Logger.error(fn _ -> "Error while retrieving movies" end)
       end
  end

  @doc ~S"""
  Return all quotes from a specific movie, queried by movie ID.

  ## Examples

      iex> TheOneAPI.movie_quotes("5cd95395de30eff6ebccde5d", limit: 2)
      [%TheOneAPI.Quote{
         id: "5cd96e05de30eff6ebcce7e9",
         character: "5cd99d4bde30eff6ebccfe9e",
         dialog: "Deagol!",
         movie: "5cd95395de30eff6ebccde5d"},
       %TheOneAPI.Quote{
         id: "5cd96e05de30eff6ebcce7ea",
         character: "5cd99d4bde30eff6ebccfe9e",
         dialog: "Deagol!",
         movie: "5cd95395de30eff6ebccde5d"},
       %TheOneAPI.Quote{
         id: "5cd96e05de30eff6ebcce7eb",
         character: "5cd99d4bde30eff6ebccfe9e",
         dialog: "Deagol!",
         movie: "5cd95395de30eff6ebccde5d"}]
  """
  def movie_quotes(id, params \\ []) do
    "/movie/#{id}/quote"
    |> get(query: params)
    |> case do
         {:ok, %Tesla.Env{body: %{"docs" => quotes = [_|_]}}} ->
           quotes
           |> Enum.map(&TheOneAPI.Quote.from_json/1)
         {:ok, _} ->
           []
         _ ->
           Logger.error(fn _ -> "Error while retrieving quotes from movie #{id}" end)
       end
  end

  @doc ~S"""
  Return list of all characters.

  ## Examples

      iex> TheOneAPI.characters(limit: 2)
      [%TheOneAPI.Character{
        id: "5cd99d4bde30eff6ebccfbbe",
        birth: "",
        death: "",
        gender: "Female",
        hair: "",
        height: "",
        name: "Adanel",
        race: "Human",
        realm: "",
        spouse: "Belemir",
        wikiUrl: "http://lotr.wikia.com//wiki/Adanel"},
      %TheOneAPI.Character{
        id: "5cd99d4bde30eff6ebccfbbf",
        birth: "Before ,TA 1944",
        death: "Late ,Third Age",
        gender: "Male",
        hair: "",
        height: "",
        name: "Adrahil I",
        race: "Human",
        realm: "",
        spouse: "",
        wikiUrl: "http://lotr.wikia.com//wiki/Adrahil_I"}]
  """
  def characters(params \\ []) do
    "/character"
    |> get(query: params)
    |> case do
         {:ok, %Tesla.Env{body: %{"docs" => characters = [_|_]}}} ->
           characters
           |> Enum.map(&TheOneAPI.Character.from_json/1)
         {:ok, _} ->
           []
         _ ->
           Logger.error(fn _ -> "Error while retrieving characters" end)
       end
  end

  @doc ~S"""
  Return a specific character by ID.

  ## Examples

      iex> TheOneAPI.character("5cd99d4bde30eff6ebccfbc0")
      [%TheOneAPI.Character{
         id: "5cd99d4bde30eff6ebccfbc0",
         birth: "TA 2917",
         death: "TA 3010",
         gender: "Male",
         hair: "",
         height: "",
         name: "Adrahil II",
         race: "Human",
         realm: "",
         spouse: "Unnamed wife",
         wikiUrl: "http://lotr.wikia.com//wiki/Adrahil_II"
         }]
  """
  def character(id, params \\ []) do
    "/character/#{id}"
    |> get(query: params)
    |> case do
         {:ok, %Tesla.Env{body: %{"docs" => character = [_]}}} ->
           character
           |> Enum.map(&TheOneAPI.Character.from_json/1)
         _ ->
           Logger.error(fn _ -> "Error while retrieving characters" end)
       end
  end

  @doc ~S"""
  Return all quotes from a specific character.

  ## Examples

      iex> TheOneAPI.character_quotes("5cd99d4bde30eff6ebccfe9e", limit: 3)
      [%TheOneAPI.Quote{
        id: "5cd96e05de30eff6ebcce7e9",
        character: "5cd99d4bde30eff6ebccfe9e",
        dialog: "Deagol!",
        movie: "5cd95395de30eff6ebccde5d"},
      %TheOneAPI.Quote{
        id: "5cd96e05de30eff6ebcce7ea",
        character: "5cd99d4bde30eff6ebccfe9e",
        dialog: "Deagol!",
        movie: "5cd95395de30eff6ebccde5d"},
      %TheOneAPI.Quote{
        id: "5cd96e05de30eff6ebcce7eb",
        character: "5cd99d4bde30eff6ebccfe9e",
        dialog: "Deagol!",
        movie: "5cd95395de30eff6ebccde5d"}]
  """
  def character_quotes(id, params \\ []) do
    "/character/#{id}/quote"
    |> get(query: params)
    |> case do
         {:ok, %Tesla.Env{body: %{"docs" => quotes = [_|_]}}} ->
           quotes
           |> Enum.map(&TheOneAPI.Quote.from_json/1)
         {:ok, _} ->
           []
         _ ->
           Logger.error(fn _ -> "Error while retrieving quotes" end)
       end
  end

  @doc ~S"""
  Return a list of all quotes.

  ## Examples

      iex> TheOneAPI.quotes(limit: 3)
      [%TheOneAPI.Quote{
        id: "5cd96e05de30eff6ebcce7e9",
        character: "5cd99d4bde30eff6ebccfe9e",
        dialog: "Deagol!",
        movie: "5cd95395de30eff6ebccde5d"},
      %TheOneAPI.Quote{
        id: "5cd96e05de30eff6ebcce7ea",
        character: "5cd99d4bde30eff6ebccfe9e",
        dialog: "Deagol!",
        movie: "5cd95395de30eff6ebccde5d"},
      %TheOneAPI.Quote{
        id: "5cd96e05de30eff6ebcce7eb",
        character: "5cd99d4bde30eff6ebccfe9e",
        dialog: "Deagol!",
        movie: "5cd95395de30eff6ebccde5d"}]
  """
  def quotes(params \\ []) do
    "/quote"
    |> get(query: params)
    |> case do
         {:ok, %Tesla.Env{body: %{"docs" => quotes = [_|_]}}} ->
           quotes
           |> Enum.map(&TheOneAPI.Quote.from_json/1)
         {:ok, _} ->
           []
         _ ->
           Logger.error(fn _ -> "Error while retrieving quotes" end)
       end
  end

  @doc ~S"""
  Return a specific quote by ID.

  There is an unfortunate naming change since `quote` is a keyword in Elixir.

  ## Examples

      iex> TheOneAPI.quotes_id("5cd96e05de30eff6ebcce810")
      [%TheOneAPI.Quote{id: "5cd96e05de30eff6ebcce810",
                        character: "5cd99d4bde30eff6ebccfc15",
                        dialog: "And thus it was a Fourth Age of Middle Earth began. And the Fellowship of the Ring, though eternally bound by friendship and love was ended. Thirteen months to the day since Gandalf sent us on our long journey we find ourselves looking upon a familiar sight.",
                        movie: "5cd95395de30eff6ebccde5d"}]
  """
  def quotes_id(id, params \\ []) do
    "/quote/#{id}"
    |> get(query: params)
    |> case do
         {:ok, %Tesla.Env{body: %{"docs" => q = [_]}}} ->
           q
           |> Enum.map(&TheOneAPI.Quote.from_json/1)
         _ ->
           Logger.error(fn _ -> "Error while retrieving characters" end)
       end
  end

  @doc ~S"""
  Return a list of chapters.

  ## Examples

      iex> TheOneAPI.chapters(limit: 3)
      [%TheOneAPI.Chapter{book: "5cf5805fb53e011a64671582",
                          id: "6091b6d6d58360f988133b8b",
                          chapterName: "A Long-expected Party"},
      %TheOneAPI.Chapter{book: "5cf5805fb53e011a64671582",
                         id: "6091b6d6d58360f988133b8c",
                         chapterName: "The Shadow of the Past"},
      %TheOneAPI.Chapter{book: "5cf5805fb53e011a64671582",
                         id: "6091b6d6d58360f988133b8d",
                         chapterName: "Three is Company"}]
  """
  def chapters(params \\ []) do
    "/chapter"
    |> get(query: params)
    |> case do
         {:ok, %Tesla.Env{body: %{"docs" => chapters = [_|_]}}} ->
           chapters
           |> Enum.map(&TheOneAPI.Chapter.from_json/1)
         {:ok, _} ->
           []
         _ ->
           Logger.error(fn _ -> "Error while retrieving chapters" end)
       end
  end

  @doc ~S"""
  Return the name of a specific chapter."

  ## Examples
      iex> TheOneAPI.chapter("6091b6d6d58360f988133b8d")
      [%TheOneAPI.Chapter{book: "5cf5805fb53e011a64671582",
                          id: "6091b6d6d58360f988133b8d",
                          chapterName: "Three is Company"}]
  """
  def chapter(id, params \\ []) do
    "/chapter/#{id}"
    |> get(query: params)
    |> case do
         {:ok, %Tesla.Env{body: %{"docs" => chapter = [_]}}} ->
           chapter
           |> Enum.map(&TheOneAPI.Chapter.from_json/1)
         {:ok, _} ->
           Logger.warn(fn _ -> "Non-unique chapter lookup by #{id}" end)
           []
         _ ->
           Logger.error(fn _ -> "Error while retrieving characters" end)
       end
  end
end
