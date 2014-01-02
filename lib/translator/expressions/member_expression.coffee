_ = require 'underscore'
AstBuilder = require '../ast_builder'

class MemberExpression
  constructor: (@object, @property) ->
  ast: ->
    _.extend computed: false, @buildAst('object', 'property')

_.extend MemberExpression::, AstBuilder::

module.exports = MemberExpression
