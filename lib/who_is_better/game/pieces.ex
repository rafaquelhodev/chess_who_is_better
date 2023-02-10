defmodule WhoIsBetter.Game.Pieces do
  def find_info(pieces) do
    Enum.map(pieces, fn piece -> piece_info(piece) end)
  end

  defp piece_info(piece) when is_binary(piece) do
    piece
    |> String.graphemes()
    |> piece_info()
  end

  defp piece_info([name, file, rank]) do
    %{name: name, file: file, rank: rank}
  end
end
