defmodule Convert do
  def dir(path) do
    files = File.ls!(path)
    files = Enum.filter(files, fn(f) -> Regex.match?(%r/.*.ex/i, f) end)
    Enum.each(files, fn(f) ->
      abs = path <> f
      IO.puts(abs)
      Convert.file(abs)
    end )
  end

  def file(path) do
    source = File.read! path
    ast = inspect Convert.ast(source)
    IO.puts(ast)
    path = path <> ".ast"
    File.write!(path, ast)
    IO.puts(path)
  end

  def ast(source) do
    Code.string_to_quoted! source
  end
end
