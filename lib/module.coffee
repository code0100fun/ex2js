class Module
  constructor: (@name) ->

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
        callee:
          type: 'FunctionExpression'
          id: null
          params: [
            type: 'Identifier'
            name: 'exports'
          ]
          defaults: []
          body:
            type: 'BlockStatement'
            rest: null
            generator: false
            expression: false
            body: [
              # Module functions and variables go here
              {
                type: 'ReturnStatement'
                argument:
                  type: 'Identifier'
                  name: 'exports'
              }
            ]
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
