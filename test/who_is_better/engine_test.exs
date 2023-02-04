defmodule WhoIsBetter.EngineTest do
  use ExUnit.Case

  alias WhoIsBetter.Engine

  describe "evaluate_position/2" do
    test "returns the score list for a position" do
      {:ok, pid} = Engine.start_link(%{reply_to: self()})

      Engine.start_new_game(pid)

      Engine.set_fen_position(pid, "6k1/1p3ppn/2p1p2p/P1P5/1P1qPb2/5P1P/3B2P1/3Q3K w - - 11 33")

      evaluation = Engine.evalute_position(pid, 10)

      Engine.stop(pid)

      GenServer.stop(pid, :normal)

      assert evaluation.score |> List.last() < 0
    end
  end
end
