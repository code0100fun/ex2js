JsAstInspector = require('./js_ast_inspector')
Method = require('../lib/translator/patterns/method')
escodegen = require('escodegen')
expect = require('chai').expect
fs = require 'fs'

describe 'Method', () ->
  beforeEach ->
    @method = new Method('bar', ['a', 'b'], 'output')
    @ast = @method.ast()

  describe '#constructor(name)', ->
    it 'creates a method with the given name', ->
      expect(@method.name).to.equal('bar')

  describe '#ast()', ->
    it 'outputs an ast for a method of the given name', ->
      expect(@ast.expression.left.object.name).to.equal('output')
      expect(@ast.expression.left.property.name).to.equal('bar')

    it 'generates an ast understandable by escodegen', ->
      js = escodegen.generate(@ast)
      expect(js).to.contain('output.bar = function (a, b)')

