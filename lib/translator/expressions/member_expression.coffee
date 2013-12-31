class MemberExpression
  constructor: (@obj, @property) ->
    console.log 'member constructor'
  type: 'MemberExpression'
  objAst: ->
    if typeof(@obj) == 'object'
      @obj.ast()
    else
      new Identifier(@obj).ast()
  propertyAst: ->
    if typeof(@property) == 'object'
      @property.ast()
    else
      new Identifier(@property).ast()
  ast: ->
    type: @type
    computed: false
    object: @objAst()
    property: @propertyAst()

module.exports = MemberExpression
