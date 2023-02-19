defmodule WhoIsBetterWeb.MatchLive do
  use WhoIsBetterWeb, :live_view

  alias WhoIsBetter.Engine
  alias WhoIsBetter.Game

  @ranks [1, 2, 3, 4, 5, 6, 7, 8]
  @files ["a", "b", "c", "d", "e", "f", "g", "h"]

  def mount(_, _, socket) do
    fen = "r1b1k1nr/p2p1pNp/n2B4/1p1NP2P/6P1/3P1Q2/P1P1K3/q5b1 b - - 0 1."

    board = Game.build_board(fen)

    {:ok, assign(socket, fen: fen, ranks: @ranks, files: @files, board: board, won: nil)}
  end

  def handle_event("check-better-" <> color, _value, socket) do
    with {:ok, evaluation} <- evaluate_position(socket.assigns.fen) do
      better = who_is_better?(evaluation)

      score = evaluation.score |> List.last() |> Kernel./(100)

      {:noreply, assign(socket, better: better, score: score, won: color == better)}
    else
      _ -> {:noreply, assign(socket, error: "Error evaluating position")}
    end
  end

  defp evaluate_position(fen) do
    {:ok, pid} = Engine.start_link(%{reply_to: self()})

    Engine.start_new_game(pid)

    Engine.set_fen_position(pid, fen)

    evaluation = Engine.evalute_position(pid, 10)

    case Map.get(evaluation, :error) do
      nil ->
        Engine.stop(pid)
        GenServer.stop(pid, :normal)
        {:ok, evaluation}

      _ ->
        GenServer.stop(pid, :normal)
        {:error, "Error evaluating position"}
    end
  end

  defp who_is_better?(%{mate: mate}) when not is_nil(mate) do
    if mate > 0 do
      "black"
    else
      "white"
    end
  end

  defp who_is_better?(evaluation) do
    evaluation.score
    |> List.last()
    |> Kernel.>(0)
    |> case do
      true -> "white"
      false -> "black"
    end
  end
end
