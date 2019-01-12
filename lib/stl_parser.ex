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

    def run(path) do    
    bitstring = read_stl(path)

    triangle_map_1l = 
      split_string(bitstring)
      |> trim_list()
      |> chunk_list()
      |> get_vertices()
        
    t_count = get_count(triangle_map_1l)
    t_area = get_area(triangle_map_1l)
    vol_box = get_volume(triangle_map_1l)

    display_analysis(t_count, t_area, vol_box)
  end

  def display_analysis(count, area, vol_box) do
    [[lx, ly, lz], [hx, hy, hz]] = vol_box

    IO.puts("Number of Triangles: #{count} \nSurface Area: #{area}\nBounding Box: {x: #{lx}, y: #{ly}, z: #{lz}}, {x: #{hx}, y: #{hy}, x: #{hz}}")
  end

  def read_stl(file) do
    {:ok, bitstring} = File.read(file)
    bitstring
  end

end