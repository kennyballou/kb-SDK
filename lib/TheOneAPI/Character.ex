defmodule TheOneAPI.Character do
  @enforce_keys [:id, :name]
  defstruct [:id, :birth, :death, :gender, :hair, :height, :name, :race, :realm, :spouse, :wikiUrl]

  @type t :: %TheOneAPI.Character{
    id: String.t(),
    name: String.t(),
    birth: String.t(),
    death: String.t(),
    gender: String.t(),
    hair: String.t(),
    height: String.t(),
    race: String.t(),
    realm: String.t(),
    spouse: String.t(),
    wikiUrl: String.t()
  }

  def from_json(character) do
    %TheOneAPI.Character{id: character["_id"],
                         name: character["name"],
                         birth: Map.get(character, "birth"),
                         death: Map.get(character, "death"),
                         gender: Map.get(character, "gender"),
                         hair: Map.get(character, "hair"),
                         height: Map.get(character, "height"),
                         race: Map.get(character, "race"),
                         realm: Map.get(character, "realm"),
                         spouse: Map.get(character, "spouse"),
                         wikiUrl: Map.get(character, "wikiUrl")
    }
  end
end
