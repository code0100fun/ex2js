Identifier = require '../types/identifier'
Expression = require './expression.coffee'

class CallExpression extends Expression
  constructor: (@callee, @args) ->
    super()
  type: 'CallExpression'
  ast: ->
    type: @type
    callee: @astOrIdentifier @callee
    arguments: @astOrIdentifier @args

module.exports = CallExpression
