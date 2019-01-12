defmodule STLParserTest do
  use ExUnit.Case
  doctest STLParser

  def line_strings_2l do
    [
      ["  facet normal 0.123828 0.316229 0.940567", 
        "   outer loop",
        "    vertex 0.516641 0.2 2.94889", 
        "    vertex 0.503588 0.35 2.90018",
        "    vertex 0.128412 0.2 3", 
        "   endloop", 
        "  endfacet"],
      ["  facet normal 0.123828 0.316228 0.940567", 
        "   outer loop",
        "    vertex 0.128412 0.2 3", 
        "    vertex 0.503588 0.35 2.90018",
        "    vertex 0.128412 0.35 2.94957", 
        "   endloop", 
        "  endfacet"
      ]
    ]
  end

  def vertices_maps_1l do
   [
      %STLParser{
        vertex_a: [0.516641, 0.2, 2.94889],
        vertex_b: [0.503588, 0.35, 2.90018],
        vertex_c: [0.128412, 0.2, 3.0]
      },
      %STLParser{
        vertex_a: [0.128412, 0.2, 3.0],
        vertex_b: [0.503588, 0.35, 2.90018],
        vertex_c: [0.128412, 0.35, 2.94957]
      }
    ]
  end

  # TODO: write invalid tests for each fn for error handling.

  # test "read_stl/1" do
  #   assert STLParser.stl_file()
  # end

  test "split_string/1" do
    s = "a \n b \r c"

    assert STLParser.split_string(s) == ["a ", " b ", " c"]
  end

  test "trim_list/1" do 
    assert STLParser.trim_list([:a, :b, :c, :d]) == [:b]
  end

  test "chunk_list/1" do
    strings_1l = ["a", "b", "c", "d", "e", "f", "g", 
                  "h", "i", "j", "k", "l", "m", "n"]
    strings_2l = [["a", "b", "c", "d", "e", "f", "g"], 
                  ["h", "i", "j", "k", "l", "m", "n"]]

    assert STLParser.chunk_list(strings_1l) == strings_2l
  end

  test "get_vertices/1" do
    assert STLParser.get_vertices(line_strings_2l) == vertices_maps_1l
  end

  test "split_coords/1" do
    s = "    vertex 0.128412 0.35 2.94957"
    l = [0.128412, 0.35, 2.94957]

    STLParser.split_coords(s) == l
  end

  test "convert_to_float/1" do
    s1 = "2.94957"
    s2 = "0"

    assert STLParser.convert_to_float(s1) == 2.94957
    assert STLParser.convert_to_float(s2) == 0.0
  end

  test "get_count/1" do
    l = [%{}, %{}]
    assert STLParser.get_count(l) == 2
  end

  test "get_area/1" do
    f = 0.06391543951501288
    assert STLParser.get_area(vertices_maps_1l) == f
  end

  test "get_volume/1" do
    bb_vals = [[0.128412, 0.2, 2.90018], [0.516641, 0.35, 3.0]]
    assert STLParser.get_volume(vertices_maps_1l) == bb_vals
  end 

  test "get_dimension_values/2"  do
    floats_1l = [2.94889, 2.90018, 3.0, 3.0, 2.90018, 2.94957]

    assert STLParser.get_dimension_values(vertices_maps_1l, 2) == floats_1l
  end

  test "get_diff/1" do
    floats_1l = [2.94889, 2.90018, 3.0, 3.0, 2.90018, 2.94957]
    floats_1t = {3.0, 2.90018}
    assert STLParser.get_diff(floats_1l) == floats_1t
  end

end
