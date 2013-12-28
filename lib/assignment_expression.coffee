class AssignmentExpression
  # TODO - handle literals and identifiers
  constructor: (@operator, @left, @right) ->
  ast: ->
    type: 'AssignmentExpression'
    operator: @operator
    left:
      type: 'Identifier'
      name: @left
    right: @right.ast()

module.exports = AssignmentExpression
