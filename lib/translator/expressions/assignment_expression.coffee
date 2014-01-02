_ = require 'underscore'
AstBuilder = require '../ast_builder'

class AssignmentExpression
  constructor: (@operator, @left, @right) ->
  ast: ->
    type: @type()
    operator: @operator
    left: @astOrIdentifier @left
    right: @astOrIdentifier @right

_.extend AssignmentExpression::, AstBuilder::

module.exports = AssignmentExpression
