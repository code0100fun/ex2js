class Return
  constructor: (@argument) ->
  argumentAst: ->
    if @argument.ast
      @argument.ast()
    else
      { type: 'Identifier', name: @argument }
  ast: ->
    type: 'ReturnStatement'
    argument: @argumentAst()

module.exports = Return
