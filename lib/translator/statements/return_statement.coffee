class ReturnStatement
  constructor: (@argument) ->
  type: 'ReturnStatement'
  argumentAst: ->
    if @argument.ast
      @argument.ast()
    else
      { type: 'Identifier', name: @argument }
  ast: ->
    type: @type
    argument: @argumentAst()

module.exports = ReturnStatement
