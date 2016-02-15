defmodule FileFormats3D.Stl.Ascii do

  def read (ascii_stl_content) do
    ascii_stl_content
    |> Stream.map(&String.rstrip/1)
    |> Stream.map(&String.split(&1, " ", trim: true))
    |> Stream.map(&parse/1)
    |> Enum.to_list
  end

  def parse(["solid"|tail]) do
    {:solid , Enum.join(tail, " ")}
  end

  def parse(["endsolid"|tail]) do
    {:end_solid , Enum.join(tail, " ")}
  end

  def parse(["facet"|tail]) do
    {:facet, parse_vector("normal", tail)}
  end

  def parse (["endfacet"]) do
    {:end_facet, nil}
  end

  def parse (["outer", "loop"]) do
    {:outer_loop, nil}
  end

  def parse (["endloop"]) do
    {:end_loop, nil}
  end

  def parse(["vertex"|_] = tokens) do
    parse_vector("vertex", tokens)
  end

  def parse(tokens) do
    line = Enum.join(tokens, " ")
    {:error, "Could not parse line \"#{line}\""}
  end

  def parse_vector(key, [key, x, y, z]) do
    {String.to_atom(key), [String.to_float(x), String.to_float(y), String.to_float(z)]}
  end
end
