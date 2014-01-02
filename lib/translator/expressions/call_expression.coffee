_ = require 'underscore'
Identifier = require '../types/identifier'
AstBuilder = require '../ast_builder'

class CallExpression
  constructor: (@callee, @arguments) ->
  ast: ->
    @buildAst('callee', 'arguments')

_.extend CallExpression::, AstBuilder::

module.exports = CallExpression
