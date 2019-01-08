# * tests each function
# * module design
# * benchmark functions
# * with, tagged tuples, multiple function clauses, type & value matching 
# * stream, process, agent, task, genserver
# * protocols, behaviors

# 1. read file
# 2. parse into structs
# 3. calculate number of triangles
# 4. calcuate total surface area
# 5. calculate bounding volume
# 6. return report


defmodule StlParser do
  @moduledoc """
  Documentation for StlParser.
  """

  def display_analysis(count, area, volume) do
    IO.puts("Triangle count: #{count} \nArea: #{area}\nVolume: #{volume}")
  end

  def runner do
    bitstring = read_stl(stl_file())

    triangle_map_1l = 
      String.split(bitstring, ~r/(\r\n|\r|\n)/)
      |> trim_list()
      |> chunk_list()
      |> get_vertices()
        
    t_count = get_count(triangle_map_1l)
    t_area = get_area(triangle_map_1l)
    t_vol = get_volume(triangle_map_1l)

    display_analysis(t_count, t_area, t_vol)
  end

  def stl_file, do: "moon.stl"

  def read_stl(file) do
    {:ok, bitstring} = File.read(file)
    bitstring
  end

  def trim_list(list) do
    Enum.slice(list, 1..-3)
  end

  def chunk_list(list) do
    Enum.chunk_every(list, 7)
  end 

  def get_vertices(chunked_2l) do
    for l <- chunked_2l do
      %{vertex_a: split_coords(Enum.at(l, 2)), 
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
        ax = m.vertex_a |> Enum.at(0)
        ay = m.vertex_a |> Enum.at(1)
        az = m.vertex_a |> Enum.at(2)

        bx = m.vertex_b |> Enum.at(0)
        by = m.vertex_b |> Enum.at(1)
        bz = m.vertex_b |> Enum.at(2)

        cx = m.vertex_c |> Enum.at(0)
        cy = m.vertex_c |> Enum.at(1)
        cz = m.vertex_c |> Enum.at(2)
        
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

    x_d = h_x - l_x
    y_d = h_y - l_y
    z_d = h_z - l_z

    x_d * y_d * z_d
  end

  def get_dimension_values(list, n) do
    for m <- list,
      v <- m do
        Enum.at(elem(v, 1), n)
    end
  end

  def get_diff(list) do
    {Enum.max(list), Enum.min(list)}
  end

end
