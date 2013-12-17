jsonpath = require('JSONPath').eval

class JsAstInspector

  constructor: (@ast) ->

  var: (name, context=@ast) ->
    jsonpath(context, "$..body[?(@.type=='VariableDeclaration')].declarations[?(@.id.name=='#{name}')]")[0]

  func: (name, context=@ast) ->
    jsonpath(context, "$..[*][?(@.type=='ExpressionStatement'&&@.expression.left.property.name=='#{name}')].expression.right")[0]

  anonymousFunc: (context=@ast) ->
    jsonpath(context, "$..[*][?(@.type=='CallExpression'&&@.callee.type=='FunctionExpression')].callee")[0]

  module: (name, context=@ast) ->
    module = @var(name, context)
    func = @anonymousFunc(context)


module.exports = JsAstInspector
