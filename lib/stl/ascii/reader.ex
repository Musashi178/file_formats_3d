defmodule FileFormats3D.Stl.Ascii.Reader do

  def read (ascii_stl_content) do
    ascii_stl_content
    |> strip_newlines_at_end_of_lines
    |> tokenize_lines
    |> parse_lines
    |> remove_unneeded_parsed_lines
    |> extract_faces
    |> Enum.to_list
  end

  defp strip_newlines_at_end_of_lines(lines), do: Stream.map(lines, &String.rstrip/1)

  defp tokenize_lines(lines), do: Stream.map(lines, &String.split(&1, " ", trim: true))

  defp parse_lines(lines), do: Stream.map(lines, &parse/1)

  def remove_unneeded_parsed_lines(lines) do
    lines |> Stream.filter(&is_required_line?/1)

  end

  def is_required_line?(parsed_line) do
    case elem(parsed_line, 0) do
      :solid -> false
      :end_solid -> false
      :outer_loop -> false
      :end_loop -> false
      :end_facet -> false
      _ -> true
    end
  end

  def extract_faces(parsed_lines) do
    parsed_lines
    |> Stream.chunk(4)
    |> Stream.map(&extract_face/1)
  end

  def extract_face([facet: {:normal, normal}, vertex: v0, vertex: v1, vertex: v2]) do
    %{normal: normal, v0: v0, v1: v1, v2: v2 }
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
