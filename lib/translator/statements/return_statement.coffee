_ = require 'underscore'
AstBuilder = require '../ast_builder'

class ReturnStatement
  constructor: (@argument) ->
  ast: ->
    @buildAst 'argument'

_.extend ReturnStatement::, AstBuilder::

module.exports = ReturnStatement
