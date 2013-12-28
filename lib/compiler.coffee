Translator = require './translator'
escodegen = require('escodegen')

class Compiler
  opitons:
    format:
      indent:
        style: '  '
        base: -2
  translate: (source) ->
    translator =  new Translator()
    translator.translate source

  compile: (source) ->
    jsAst = @translate source
    escodegen.generate jsAst, @opitons

module.exports = Compiler
