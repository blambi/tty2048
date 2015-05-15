defmodule Tty2048.Grid.Formatter do
  def format(grid) do
    Enum.map(grid, &[format_row(&1), "\r\n"])
    |> IO.ANSI.format_fragment
  end

  defp format_row(row) do
    Enum.map(row, &format_cell/1)
  end

  @empty_cell [:faint, :white, " ", :reset]

  defp format_cell(0), do: @empty_cell
  defp format_cell(num) do
    integer_to_string(num)
    |> String.rjust(2)
    |> format_cell(num)
  end

  defp integer_to_string(num) when num < 1000 do
    Integer.to_string(num)
  end

  defp integer_to_string(num) do
    Integer.to_string(div(num, 1000)) <> "k"
  end

  defp format_cell(data, num) do
    case num do
      -1 -> [:red, '◪', :reset]
      x when x < 128 -> colorify(num) ++ ['■', :reset]
      x when x > 64 -> colorify(num) ++ ['▲', :reset]
    end
  end

  defp colorify(num) do
    case num do
      2    -> [:green]
      4    -> [:yellow]
      8    -> [:cyan]
      16   -> [:blue]
      32   -> [:red]
      64   -> [:magenta]
      128  -> [:bright, :yellow]  # Bright
      256  -> [:bright, :cyan]    # Bright
      512  -> [:bright, :blue]    # Bright
      1024 -> [:bright, :magenta] # Bright
      2048 -> [:bright, :red]     # Bright
      _    -> [:white]
    end
  end
end
