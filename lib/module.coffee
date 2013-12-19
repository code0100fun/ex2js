FunctionExpression = require('./function_expression')
ReturnStatement = require('./return_statement')

class Module
  constructor: (@name) ->
    @methods = []
  methods: undefined
  exports: 'exports'
  functionAst: ->
    func = new FunctionExpression([@exports])
    for method in @methods
      func.body.push method
    func.body.push(new ReturnStatement(@exports))
    func.ast()
  ast: ->
    type: 'VariableDeclaration'
    kind: 'var'
    declarations: [
      type: 'VariableDeclarator'
      id:
        type: 'Identifier'
        name: @name
      init:
        type: 'CallExpression'
        callee: @functionAst()
        arguments: [
          type: 'LogicalExpression'
          operator: '||'
          left:
            type: 'Identifier'
            name: @name
          right:
            type: 'ObjectExpression'
            properties: []
        ]
    ]

module.exports = Module
