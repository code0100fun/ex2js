Expression = require './expression.coffee'

class AssignmentExpression extends Expression
  # TODO - handle literals and identifiers
  constructor: (@operator, @left, @right) ->
    super()
  type: 'AssignmentExpression'
  ast: ->
    type: @type
    operator: @operator
    left:
      type: 'Identifier'
      name: @left
    right: @right.ast()

module.exports = AssignmentExpression
