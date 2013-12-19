Ex2js = {}
Ex2js.Function = require('./function')
Return = require('./return')

class Module
  constructor: (@name) ->
    @methods = []
  methods: undefined
  exports: 'exports'
  functionAst: ->
    func = new Ex2js.Function([@exports])
    for method in @methods
      func.body.push method
    func.body.push(new Return(@exports))
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
