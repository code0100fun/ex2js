JsAstInspector = require('./js_ast_inspector')
FunctionExpression = require('../lib/translator/expressions/function_expression')
ExpressionStatement = require('../lib/translator/statements/expression_statement')
BinaryExpression = require('../lib/translator/expressions/binary_expression')
escodegen = require('escodegen')
expect = require('chai').expect
fs = require 'fs'

describe 'FunctionExpression', () ->
  beforeEach ->
    @func = new FunctionExpression(['a', 'b'])
    @func.addStatement new ExpressionStatement(new BinaryExpression('+', 'a', 'b'))
    @ast = @func.ast()

  describe '#constructor(name)', ->
    it 'creates a function that takes the given parameters', ->
      expect(@func.params).to.eql(['a', 'b'])

  describe '#ast()', ->
    it 'outputs an ast for a function with the given parameters', ->
      expect(@ast.type).to.equal('FunctionExpression')
      expect(@ast.id).to.equal(null)
      expect(@ast.params[0].name).to.equal('a')
      expect(@ast.params[1].name).to.equal('b')

    it 'generates an ast understandable by escodegen', ->
      js = escodegen.generate(@ast)
      expect(js.replace(/\s/g, '')).to.contain('function(a,b)')

    it 'adds return statment to the last statment if it is not a retun statment', ->
      js = escodegen.generate(@ast)
      expect(js).to.contain('return a + b;')

