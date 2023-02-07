defmodule WhoIsBetter.Game do
  alias WhoIsBetter.Game.Board.Square
  alias WhoIsBetter.Game.Parser.Fen

  def which_color(file, rank) do
    Square.color(file, rank)
  end

  def build_board(fen) do
    Fen.translate_fen(fen)
  end
end
