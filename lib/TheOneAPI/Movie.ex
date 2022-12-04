defmodule TheOneAPI.Movie do
  @enforce_keys [:id, :name]
  defstruct [:id,
             :name,
             :academyAwardNominations,
             :academyAwardWins,
             :boxOfficeRevenueInMillions,
             :budgetInMillions,
             :rottenTomatoesScore,
             :runtimeInMinutes
            ]

  @type t :: %TheOneAPI.Movie{id: String.t(),
                              name: String.t(),
                              academyAwardNominations: integer(),
                              academyAwardWins: integer(),
                              boxOfficeRevenueInMillions: integer(),
                              budgetInMillions: integer(),
                              rottenTomatoesScore: integer(),
                              runtimeInMinutes: integer()
  }

  def from_json(movie) do
    %TheOneAPI.Movie{id: movie["_id"],
                     name: movie["name"],
                     academyAwardNominations: Map.get(movie, "academyAwardNominations"),
                     academyAwardWins: Map.get(movie, "academyAwardWins"),
                     boxOfficeRevenueInMillions: Map.get(movie, "boxOfficeRevenueInMillions"),
                     budgetInMillions: Map.get(movie, "budgetInMillions"),
                     rottenTomatoesScore: Map.get(movie, "rottenTomatoesScore"),
                     runtimeInMinutes: Map.get(movie, "runtimeInMinutes")
    }
  end
end
