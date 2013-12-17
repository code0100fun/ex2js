JsAstInspector = require('../lib/js_ast_inspector')
Module = require('../lib/module')
escodegen = require('escodegen')
expect = require('chai').expect
fs = require 'fs'

describe 'Module', () ->
  beforeEach ->

  describe '#constructor(name)', ->
    it 'creates a module with the given name', ->
      module = new Module('Foo')
      expect(module.name).to.equal('Foo')

  describe '#ast()', ->
    it 'outputs an ast for a module of the given name', ->
      module = new Module('Foo')
      ast = module.ast()
      expect(ast.type).to.equal('VariableDeclaration')
      expect(ast.declarations[0].id.name).to.equal('Foo')

    it 'generates an ast understandable by escodegen', ->
      module = new Module('Foo')
      ast = module.ast()
      js = escodegen.generate(ast)
      expect(js).to.contain('var Foo')
