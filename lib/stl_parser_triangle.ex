defmodule STLParser.Triangle do
  @moduledoc """
  Documentation for STLParser.Triangle
  """
  alias STLParser.Triangle

  defstruct [:vertex_a, :vertex_b, :vertex_c]

  def split_string(s), do: String.split(s, ~r/(\r\n|\r|\n)/)

  def trim_list(list) do
    Enum.slice(list, 1..-3)
  end

  def chunk_list(list) do
    Enum.chunk_every(list, 7)
  end 

  def get_vertices(chunked_2l) do
    for l <- chunked_2l do
      %Triangle{
        vertex_a: split_coords(Enum.at(l, 2)),
        vertex_b: split_coords(Enum.at(l, 3)),
        vertex_c: split_coords(Enum.at(l, 4))
      }
    end
  end

  def split_coords(string) do
    string
    |> String.trim_leading("    vertex ")
    |> String.split(" ")
    |> Enum.map(fn(x)-> convert_to_float(x) end)
  end

  def convert_to_float(string) do
    cond do
      String.contains?(string, ".") -> String.to_float(string)
      true -> String.to_float(string <> ".0")
    end
  end

  def get_count(map_list) do
    Enum.count(map_list)
  end

  def get_area(maps_1l) do
    t_areas = 
      for m <- maps_1l do
        [ax, ay, az] = m.vertex_a
        [bx, by, bz] = m.vertex_b
        [cx, cy, cz] = m.vertex_c
        
        ab = :math.sqrt(:math.pow(bx - ax, 2) + :math.pow(by - ay, 2) + :math.pow(bz - az, 2))        
        ac = :math.sqrt(:math.pow(cx - ax, 2) + :math.pow(cy - ay, 2) + :math.pow(cz - az, 2))

        ab * ac / 2
      end
  
    Enum.reduce(t_areas, 0, fn(a, acc)-> a + acc end)
  end

  def get_volume(maps_1l) do
    xvals_l = get_dimension_values(maps_1l, 0)
    yvals_l = get_dimension_values(maps_1l, 1)
    zvals_l = get_dimension_values(maps_1l, 2)

    {h_x, l_x} = get_diff(xvals_l)
    {h_y, l_y} = get_diff(yvals_l)
    {h_z, l_z} = get_diff(zvals_l)

    # x_d = h_x - l_x
    # y_d = h_y - l_y
    # z_d = h_z - l_z
    # total_volume = x_d * y_d * z_d

    [[l_x, l_y, l_z], [h_x, h_y, h_z]]
  end

  def get_dimension_values(list, n) do
    for m <- list do
      a = m.vertex_a |> Enum.at(n)
      b = m.vertex_b |> Enum.at(n)
      c = m.vertex_c |> Enum.at(n)

      [a, b, c]
    end
    |> List.flatten
  end

  def get_diff(list) do
    {Enum.max(list), Enum.min(list)}
  end

end
