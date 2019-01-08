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
    display_analysis(t_count, nil, nil)

    get_area(triangle_map_1l)

    # triangle_map_1l
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
    for m <- maps_1l do
      m
    end
  end

  def get_volume(maps_1l) do
    
  end

end
