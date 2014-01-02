_ = require 'underscore'
AstBuilder = require '../ast_builder'

class BinaryExpression
  constructor: (@operator, @left, @right) ->
  ast: ->
    type: @type()
    operator: @operator
    left: @astOrIdentifier @left
    right: @astOrIdentifier @right

_.extend BinaryExpression::, AstBuilder::

module.exports = BinaryExpression
