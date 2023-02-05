defmodule WhoIsBetter.Game.Parser.FenTest do
  use ExUnit.Case

  alias WhoIsBetter.Game.Parser.Fen

  describe "translate_fen/1" do
    test "gets the positions for each piece in the board" do
      fen = "8/8/8/4p1K1/2k1P3/8/8/8 b - - 0 1."

      translation = Fen.translate_fen(fen)

      assert translation.board == ["pe5", "Kg5", "kc4", "Pe4"]
      assert translation.turn == :black
    end

    test "gets the positions for each piece in the board when white is next" do
      fen = "r1b1k1nr/p2p1pNp/n2B4/1p1NP2P/6P1/3P1Q2/P1P1K3/q5b1 w - - 0 1."

      translation = Fen.translate_fen(fen)

      assert translation.board == [
               "ra8",
               "bc8",
               "ke8",
               "ng8",
               "rh8",
               "pa7",
               "pd7",
               "pf7",
               "Ng7",
               "ph7",
               "na6",
               "Bd6",
               "pb5",
               "Nd5",
               "Pe5",
               "Ph5",
               "Pg4",
               "Pd3",
               "Qf3",
               "Pa2",
               "Pc2",
               "Ke2",
               "qa1",
               "bg1"
             ]

      assert translation.turn == :white
    end
  end
end
