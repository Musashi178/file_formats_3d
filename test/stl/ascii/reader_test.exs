defmodule FileFormats3DTest.Stl.Ascii.Reader do
  use ExUnit.Case
  doctest FileFormats3D.Stl.Ascii.Reader

  alias FileFormats3D.Stl.Ascii

  test "read" do
    assert 86 == Ascii.Reader.read(File.stream!("test/_data/stl/cube_ascii.stl"))
  end

  test "parse solid line" do
    assert {:solid, "Exported from Blender-2.76 (sub 0)"} = Ascii.Reader.parse(["solid", "Exported", "from", "Blender-2.76", "(sub", "0)"])
  end

  test "parse endsolid line" do
    assert {:end_solid, "Exported from Blender-2.76 (sub 0)"} = Ascii.Reader.parse(["endsolid", "Exported", "from", "Blender-2.76", "(sub", "0)"])
  end

  test "parse facet line" do
    assert {:facet, {:normal, [-0.0, 0.0, -1.0]}} = Ascii.Reader.parse(["facet", "normal", "-0.000000", "0.000000", "-1.000000"])
  end

  test "parse endfacet line" do
    assert {:end_facet, _} = Ascii.Reader.parse(["endfacet"])
  end

  test "parse outer loop" do
    assert {:outer_loop, _} = Ascii.Reader.parse(["outer", "loop"])
  end

  test "parse endloop line" do
    assert {:end_loop, _} = Ascii.Reader.parse(["endloop"])
  end

  test "parse vertex line" do
    assert {:vertex, [1.0, 1.0, -1.0]}= Ascii.Reader.parse(["vertex", "1.000000", "1.000000", "-1.000000"])
  end

  test "parse vertex with exp coords" do
    assert {:vertex, [-3.1533, 6.664, -12.4451]}= Ascii.Reader.parse(["vertex", "-0.315330E+01",  "0.666400E+01", "-0.124451E+02"])
  end
end
