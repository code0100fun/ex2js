JsAstInspector = require('./js_ast_inspector')
Module = require('../lib/translator/patterns/module')
Method = require('../lib/translator/patterns/method')
escodegen = require('escodegen')
expect = require('chai').expect
fs = require 'fs'

describe 'Module', () ->
  beforeEach ->
    @module = new Module('Foo')
    method = new Method('bar', ['a', 'b'])
    @module.methods.push method
    @ast = @module.ast()

  describe '#constructor(name)', ->
    it 'creates a module with the given name', ->
      expect(@module.name).to.equal('Foo')

  describe '#ast()', ->
    it 'outputs an ast for a module of the given name', ->
      expect(@ast.type).to.equal('VariableDeclaration')
      expect(@ast.declarations[0].id.name).to.equal('Foo')

    it 'generates an ast understandable by escodegen', ->
      js = escodegen.generate(@ast)
      expect(js).to.contain('var Foo')

    it 'adds methods to the exported object', ->
      js = escodegen.generate(@ast)
      expect(js).to.contain('exports.bar = function')

    it 'returns the exported object', ->
      js = escodegen.generate(@ast)
      expect(js).to.contain('return exports;')

