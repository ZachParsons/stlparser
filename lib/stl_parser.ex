# * tests each function
# * module design
# * benchmark functions
# * with, tagged tuples, multiple function clauses, type & value matching 
# * Process, Agent, Task, GenServer
# * protocols, behaviors

# 1. read file
# 2. parse into structs
# 3. calculate number of triangles
# 4. calcuate total surface area
# 5. calculate bounding volume
# 6. return report

defmodule STLParser do
  import STLParser.Triangle

  # Function called in the CLI.
  @spec run(binary()) :: binary()
  def run(path) do
    # Gets content of file.
    bitstring = read_stl(path)

    # Lists all triangle structs.
    triangles_1l = 
      split_string(bitstring)
      |> trim_list()
      |> chunk_list()
      |> get_vertices()
    
    # Calculates from the list of triangle structs.
    t_count = get_triangles_count(triangles_1l)
    t_area = get_triangles_area(triangles_1l)
    vol_box = get_triangles_volume_box(triangles_1l)

    # Prints calculations.
    display_report(t_count, t_area, vol_box)
  end

  @spec display_report(integer(), float(), list()) :: String.t()
  def display_report(count, area, vol_box) do
    [[lx, ly, lz], [hx, hy, hz]] = vol_box

    IO.puts("Number of Triangles: #{count} \nSurface Area: #{area}\nBounding Box: {x: #{lx}, y: #{ly}, z: #{lz}}, {x: #{hx}, y: #{hy}, x: #{hz}}")
  end

  # STL: Standard Triangle Language
  @spec read_stl(binary()) :: binary()
  def read_stl(file) do
    {:ok, bitstring} = File.read(file)
    bitstring
  end

end