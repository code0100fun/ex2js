_ = require 'underscore'
AstBuilder = require '../ast_builder'

class ReturnStatement
  constructor: (@argument) ->
  ast: ->
    type: @type()
    argument: @astOrIdentifier @argument

_.extend ReturnStatement::, AstBuilder::

module.exports = ReturnStatement
