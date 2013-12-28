defmodule Converter do
  def dir(path) do
    files = File.ls!(path)
    files = Enum.filter(files, fn(f) -> Regex.match?(%r/.*.ex/i, f) end)
    Enum.each(files, fn(f) ->
      abs = path <> f
      ast = Converter.file(abs)
      path = path <> ".ast"
      File.write!(path, ast)
    end )
  end

  def file(path) do
    source = File.read! path
    inspect Converter.ast(source)
  end

  def ast(source) do
    Code.string_to_quoted! source
  end
end
