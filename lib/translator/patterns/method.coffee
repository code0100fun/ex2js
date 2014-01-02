FunctionExpression = require('../expressions/function_expression')

class Method
  constructor: (@name, @params=[], @exports='exports') ->
    @body = []
  body: undefined
  functionAst: ->
    func = new FunctionExpression(@params)
    func.addStatement(s) for s in @body
    func.ast()
  ast: ->
    type: 'ExpressionStatement'
    expression:
      type: 'AssignmentExpression'
      operator: '='
      left:
        type: 'MemberExpression'
        computed: false
        object:
          type: 'Identifier'
          name: @exports
        property:
          type: 'Identifier'
          name: @name
      right: @functionAst()

module.exports = Method
