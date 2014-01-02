_ = require 'underscore'
AstBuilder = require '../ast_builder'

class ExpressionStatement
  constructor: (@expression) ->
  ast: ->
    @buildAst 'expression'

_.extend ExpressionStatement::, AstBuilder::

module.exports = ExpressionStatement
