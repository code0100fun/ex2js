Ex2js = {}
Ex2js.Function = require('../lib/function')

class Module
  constructor: (@name) ->
  methods: []
  exports: 'exports'
  returnAst: ->
    {
      type: 'ReturnStatement'
      argument:
        type: 'Identifier'
        name: @exports
    }
  functionAst: ->
    func = new Ex2js.Function([@exports])
    func.body.push @returnAst()
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
