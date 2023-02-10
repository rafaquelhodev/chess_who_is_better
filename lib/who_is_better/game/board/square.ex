defmodule WhoIsBetter.Game.Board.Square do
  require Integer

  def color(file, rank) when file in ["a", "c", "e", "g"] do
    case Integer.is_even(rank) do
      true -> :white
      false -> :black
    end
  end

  def color(file, rank) when file in ["b", "d", "f", "h"] do
    case Integer.is_even(rank) do
      true -> :black
      false -> :white
    end
  end
end
