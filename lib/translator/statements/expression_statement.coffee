_ = require 'underscore'
AstBuilder = require '../ast_builder'

class ExpressionStatement
  constructor: (@expression) ->
  ast: ->
    type: @type()
    expression: @astOrIdentifier @expression

_.extend ExpressionStatement::, AstBuilder::

module.exports = ExpressionStatement
