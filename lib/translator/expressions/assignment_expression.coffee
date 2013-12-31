Expression = require './expression.coffee'

class AssignmentExpression extends Expression
  constructor: (@operator, @left, @right) ->
    super()
  type: 'AssignmentExpression'
  ast: ->
    type: @type
    operator: @operator
    left: @astOrIdentifier @left
    right: @astOrIdentifier @right

module.exports = AssignmentExpression
