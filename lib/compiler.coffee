Translator = require './translator'
escodegen = require('escodegen')

class Compiler
  translate: (source) ->
    translator =  new Translator()
    translator.translate source

  compile: (source) ->
    jsAst = @translate source
    escodegen.generate jsAst

module.exports = Compiler
