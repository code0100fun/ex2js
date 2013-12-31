Expression = require './expression'

class MemberExpression extends Expression
  constructor: (@obj, @property) ->
    super()
  type: 'MemberExpression'
  ast: ->
    type: @type
    computed: false
    object: @astOrIdentifier @obj
    property: @astOrIdentifier @property

module.exports = MemberExpression
