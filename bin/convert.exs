#! /usr/bin/env elixir

Code.require_file "converter.exs", __DIR__

file = Enum.fetch!(System.argv, 0)
cwd = System.cwd!()
abs = Path.absname(file, cwd)
ast = Converter.file(abs)
IO.puts(ast)
