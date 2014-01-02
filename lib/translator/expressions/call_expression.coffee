_ = require 'underscore'
Identifier = require '../types/identifier'
AstBuilder = require '../ast_builder'

class CallExpression
  constructor: (@callee, @args) ->
  ast: ->
    type: @type()
    callee: @astOrIdentifier @callee
    arguments: @astOrIdentifier @args

_.extend CallExpression::, AstBuilder::

module.exports = CallExpression
