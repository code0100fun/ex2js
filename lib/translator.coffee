Parser = require './parser'

class Translator

  parse: (source) ->
    parser = new Parser()
    parser.parse(source)

  translate: (source) ->
    { type:'Program', body:[]}

module.exports = Translator
