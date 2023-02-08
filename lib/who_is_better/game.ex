defmodule WhoIsBetter.Game do
  alias WhoIsBetter.Game.Board.Square
  alias WhoIsBetter.Game.Pieces
  alias WhoIsBetter.Game.Parser.Fen

  def which_color(file, rank) do
    Square.color(file, rank)
  end

  def build_board(fen) do
    match = Fen.translate_fen(fen)

    pieces = Pieces.find_info(match.board)

    match
    |> Map.put(:pieces, pieces)
  end
end
