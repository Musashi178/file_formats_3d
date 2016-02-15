defmodule FileFormats3DTest.Stl.Ascii do
  use ExUnit.Case
  doctest FileFormats3D.Stl.Ascii

  alias FileFormats3D.Stl.Ascii

  test "read" do
    {:ok, ascii_cube_content} = File.read("test/_data/stl/cube_ascii.stl")
    assert [] == Ascii.read(ascii_cube_content)
  end
end
