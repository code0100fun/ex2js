JsAstInspector = require('../lib/js_ast_inspector')
Function = require('../lib/function')
escodegen = require('escodegen')
expect = require('chai').expect
fs = require 'fs'

describe 'Function', () ->
  beforeEach ->

  describe '#constructor(name)', ->
    it 'creates a function that takes the given parameters', ->
      func = new Function(['a', 'b'])
      expect(func.params).to.eql(['a', 'b'])

  describe '#ast()', ->
    it 'outputs an ast for a function with the given parameters', ->
      func = new Function(['a', 'b'])
      ast = func.ast()
      expect(ast.type).to.equal('FunctionExpression')
      expect(ast.id).to.equal(null)
      expect(ast.params[0].name).to.equal('a')
      expect(ast.params[1].name).to.equal('b')

    it 'generates an ast understandable by escodegen', ->
      func = new Function(['a', 'b'])
      ast = func.ast()
      js = escodegen.generate(ast)
      expect(js.replace(/\s/g, '')).to.contain('function(a,b)')

