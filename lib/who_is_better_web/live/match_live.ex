defmodule WhoIsBetterWeb.MatchLive do
  use WhoIsBetterWeb, :live_view

  @ranks [1, 2, 3, 4, 5, 6, 7, 8]
  @files ["a", "b", "c", "d", "e", "f", "g", "h"]

  def mount(_, _, socket) do
    {:ok, assign(socket, fen: "test", ranks: @ranks, files: @files)}
  end
end
