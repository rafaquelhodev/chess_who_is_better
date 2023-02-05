defmodule WhoIsBetter.Game do
  alias WhoIsBetter.Game.Parser.Fen

  def build_board(fen) do
    Fen.translate_fen(fen)
  end
end
