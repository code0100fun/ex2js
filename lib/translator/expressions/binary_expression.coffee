_ = require 'underscore'
AstBuilder = require '../ast_builder'

#TODO - Combine BinaryExoression and AssignmentExpression
class BinaryExpression
  constructor: (@operator, @left, @right) ->
  ast: ->
    _.extend operator: @operator, @buildAst('left', 'right')

_.extend BinaryExpression::, AstBuilder::

module.exports = BinaryExpression
