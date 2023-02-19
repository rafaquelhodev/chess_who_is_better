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

    test "evaluates when black has a mate sequence" do
      {:ok, pid} = Engine.start_link(%{reply_to: self()})

      Engine.start_new_game(pid)

      Engine.set_fen_position(pid, "1K6/7q/2k5/8/8/8/8/8 b - - 0 1")

      evaluation = Engine.evalute_position(pid, 10)

      Engine.stop(pid)

      GenServer.stop(pid, :normal)

      assert evaluation.mate > 0
    end

    test "evaluates when white has a mate sequence" do
      {:ok, pid} = Engine.start_link(%{reply_to: self()})

      Engine.start_new_game(pid)

      Engine.set_fen_position(
        pid,
        "r1b1k1nr/p2p1pNp/n2B4/1p1NP2P/6P1/3P1Q2/P1P1K3/q5b1 b - - 0 1"
      )

      evaluation = Engine.evalute_position(pid, 10)

      Engine.stop(pid)

      GenServer.stop(pid, :normal)

      assert evaluation.mate < 0
    end

    test "returns an error when the fen is invalid" do
      {:ok, pid} = Engine.start_link(%{reply_to: self()})

      Engine.start_new_game(pid)

      Engine.set_fen_position(
        pid,
        "r1b1k1nr/p2p1pNp/n2B4/1p1NP2P/6P1/3P1Q2/P1P1K3/q5b1 w - - 0 1"
      )

      evaluation = Engine.evalute_position(pid, 10)

      assert not is_nil(evaluation.error)
    end
  end
end
