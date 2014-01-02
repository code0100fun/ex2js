_ = require 'underscore'
AstBuilder = require '../ast_builder'

class AssignmentExpression
  constructor: (@operator, @left, @right) ->
  ast: ->
    _.extend operator: @operator, @buildAst('left', 'right')

_.extend AssignmentExpression::, AstBuilder::

module.exports = AssignmentExpression
