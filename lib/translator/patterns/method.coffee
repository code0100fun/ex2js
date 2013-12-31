FunctionExpression = require('../expressions/function_expression')

class Method
  constructor: (@name, @params=[], @exports='exports') ->
    @body = []
  body: undefined
  functionAst: ->
    func = new FunctionExpression(@params)
    func.body = @body
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
