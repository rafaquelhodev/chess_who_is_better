defmodule WhoIsBetterWeb.MatchLive do
  use WhoIsBetterWeb, :live_view

  alias WhoIsBetter.Game

  @ranks [1, 2, 3, 4, 5, 6, 7, 8]
  @files ["a", "b", "c", "d", "e", "f", "g", "h"]

  def mount(_, _, socket) do
    fen = "r1b1k1nr/p2p1pNp/n2B4/1p1NP2P/6P1/3P1Q2/P1P1K3/q5b1 w - - 0 1."

    board = Game.build_board(fen)

    {:ok, assign(socket, fen: "test", ranks: @ranks, files: @files, board: board)}
  end
end
