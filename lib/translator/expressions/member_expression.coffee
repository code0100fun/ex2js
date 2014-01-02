_ = require 'underscore'
AstBuilder = require '../ast_builder'

class MemberExpression
  constructor: (@obj, @property) ->
  ast: ->
    type: @type()
    computed: false
    object: @astOrIdentifier @obj
    property: @astOrIdentifier @property

_.extend MemberExpression::, AstBuilder::

module.exports = MemberExpression
