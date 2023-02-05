defmodule WhoIsBetter.Game.Parser.Fen do
  @start_row 8
  @start_rank "a"

  @rank_map %{1 => "a", 2 => "b", 3 => "c", 4 => "d", 5 => "e", 6 => "f", 7 => "g", 8 => "h"}

  def translate_fen(fen) do
    %{moves: moves, not_moves: not_moves} = split_fen(fen)

    translation = find_pieces_poisitions(moves)

    turn = find_turn(not_moves)

    translation
    |> Map.put(:turn, turn)
    |> Map.take([:board, :turn])
  end

  defp split_fen(fen) do
    [moves | not_moves] =
      fen
      |> String.split(" ")

    %{moves: moves, not_moves: not_moves}
  end

  defp find_turn(_not_moves = ["b" | _]), do: :black
  defp find_turn(_not_moves), do: :white

  defp find_pieces_poisitions(moves) do
    moves
    |> String.split("/")
    |> Enum.reduce(%{row_number: @start_row, board: []}, fn row, acc ->
      resp = read_row(row, acc.row_number, acc.board)
      %{board: resp.board, row_number: acc.row_number - 1}
    end)
  end

  defp read_row(row, row_number, board) do
    row
    |> String.graphemes()
    |> Enum.reduce(%{board: board, rank_number: 1}, fn el, acc ->
      case Integer.parse(el) do
        {n_jump, _} ->
          Map.put(acc, :rank_number, acc.rank_number + n_jump)

        _ ->
          new_board = acc.board ++ [el <> Map.get(@rank_map, acc.rank_number) <> "#{row_number}"]
          acc = Map.put(acc, :board, new_board)
          Map.put(acc, :rank_number, acc.rank_number + 1)
      end
    end)
  end
end
