defmodule TheOneAPI.Quote do
  @enforce_keys [:id, :dialog]
  defstruct [:id, :character, :dialog, :movie]

  @type t :: %TheOneAPI.Quote{id: String.t(), character: String.t(), dialog: String.t(), movie: String.t()}

  def from_json(quote_map) do
    %TheOneAPI.Quote{id: quote_map["_id"],
                     character: quote_map["character"],
                     dialog: quote_map["dialog"],
                     movie: quote_map["movie"]}
  end
end
