Identifier = require '../types/identifier'
Expression = require './expression.coffee'

class CallExpression extends Expression
  constructor: (@callee, @args) ->
    super()
  type: 'CallExpression'
  astOrIdentifier: (obj) ->
    if obj.constructor == Array
      obj.map (a) => @astOrIdentifier(a)
    else if typeof(obj) == 'object'
      obj.ast()
    else
      new Identifier(obj).ast()
  calleeAst: ->
    if typeof(@callee) == 'object'
      @callee.ast()
    else
      new Identifier(@callee).ast()
  argsAst: ->
    if @args.constructor == Array
      @args.map (a) => @astOrIdentifier(a)
    else if typeof(@args) == 'object'
      @args.ast()
    else
      new Identifier(@args).ast()
  ast: ->
    type: 'CallExpression'
    callee: @calleeAst()
    arguments: @argsAst()

module.exports = CallExpression
