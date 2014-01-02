_ = require 'underscore'
BlockStatement = require '../statements/block_statement'
AstBuilder = require '../ast_builder'

class FunctionExpression
  constructor: (@params) ->
    @body = new BlockStatement()
  addStatement: (statement) ->
    @body.addStatement statement
  ast: ->
    _.extend id:null, defaults:[], @buildAst('params', 'body')

_.extend FunctionExpression::, AstBuilder::

module.exports = FunctionExpression
