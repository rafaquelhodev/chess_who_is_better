defmodule WhoIsBetter.Engine do
  use GenServer

  def start_link(args \\ [], opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  @impl GenServer
  def init(_) do
    port =
      Port.open(
        {:spawn, Application.get_env(:stockfish, :engine_path, "/usr/local/bin/stockfish")},
        [:binary, :exit_status]
      )

    Port.command(port, "uci\n")

    {:ok, %{port: port, evaluation: %{best_move: nil, score: [], mate: nil}}}
  end

  @impl GenServer
  def handle_info({_port, {:data, data}}, state) do
    state = parse_evaluation(state, data)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({_port, {:exit_status, status}}, state) do
    state = Map.put(state, :error, status)
    GenServer.reply(state.reply_to, state)
    {:noreply, state}
  end

  @impl GenServer
  def handle_call({:set_fen, fen}, _, state) do
    Port.command(state.port, "position fen #{fen}\n")
    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_call({:start_game}, _, state) do
    Port.command(state.port, "ucinewgame\n")

    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_call({:eval_pos, depth}, from, state) do
    Port.command(state.port, "go depth #{depth}\n")

    state = state |> Map.put(:reply_to, from)

    {:noreply, state}
  end

  @impl GenServer
  def handle_call({:stop}, _, state) do
    Port.command(state.port, "stop\n")
    {:reply, :ok, state}
  end

  def start_new_game(pid) do
    GenServer.call(pid, {:start_game})
  end

  def set_fen_position(pid, fen) do
    GenServer.call(pid, {:set_fen, fen}, 15_000)
  end

  def evalute_position(pid, depth) do
    GenServer.call(pid, {:eval_pos, depth})
  end

  def stop(pid) do
    GenServer.call(pid, {:stop})
  end

  defp parse_evaluation(state, data) do
    cond do
      String.contains?(data, "bestmove") == true ->
        r = ~r/bestmove (?<move>[abcdefgh][1-8][abcdefgh][1-8])/
        %{"move" => move} = Regex.named_captures(r, data)

        state = put_in(state.evaluation.best_move, move)

        GenServer.reply(state.reply_to, state.evaluation)

        state

      String.contains?(data, "score cp") == true ->
        {score, _} =
          ~r/(?<=score cp).*(?= nodes)/
          |> Regex.run(data)
          |> List.first()
          |> String.trim()
          |> Integer.parse()

        new_score = state.evaluation.score ++ [score]
        put_in(state.evaluation.score, new_score)

      String.contains?(data, "score mate") == true ->
        {mate, _} =
          ~r/(?<=score mate).*(?= nodes)/
          |> Regex.run(data)
          |> List.first()
          |> String.trim()
          |> Integer.parse()

        put_in(state.evaluation.mate, mate)

      true ->
        state
    end
  end
end
