Translator = require('../lib/translator')
JsAstInspector = require('../lib/js_ast_inspector')
expect = require('chai').expect
fs = require 'fs'

describe 'Translator', () ->

  moduleAst = { name: 'defmodule', params:[
      {},
      [
        { name: '__aliases__', params: [{},['Foo']] },
        { do: {} }
      ]
  ] }

  methodAst = { name: 'def', params:[
      {},
      [
        { name: 'bar', params: [{},[
          { name: 'a', params: [] },
          { name: 'b', params: [] },
        ]] },
        { do: {} }
      ]
  ] }

  addAst = { name: '+', params: [ {}, [
    { name: 'a', params:[{},null] },
    { name: 'b', params:[{},null] }
  ]]}

  beforeEach ->
    @source = fs.readFileSync('./fixtures/math.ex.ast').toString()
    @translator = new Translator()

  describe '#translate(source)', ->
    it 'wraps code in a Program object', (done) ->
      jsAst = @translator.translate @source
      expect(jsAst['type']).to.equal('Program')
      expect(jsAst['body']).to.be.a('array')
      done()

    it 'creates a variable with the name of the module', ->
      jsAst = @translator.translate @source
      inspector = new JsAstInspector(jsAst)
      path = inspector.var('Math')
      expect(path.id.name).to.equal('Math')

  describe '#statement(exAst)', ->
    it 'creates a module object when given an Elixir AST for a module', ->
      module = @translator.statement moduleAst
      expect(module.name).to.equal('Foo')

    it 'constructs a binary expression statement given the ast for an addition', ->
      add = @translator.statement addAst
      expect(add.expression.operator).to.equal('+')
      expect(add.expression.a).to.equal('a')
      expect(add.expression.b).to.equal('b')

  describe '#method(exAst)', ->
    it 'constructs a method given the ast for a method', ->
      method = @translator.method methodAst
      expect(method.name).to.equal('bar')


  describe '#module(exAst)', ->
    it 'constructs a module given the ast for a module', ->
      module = @translator.module moduleAst
      expect(module.name).to.equal('Foo')

  describe '#parse(source)', ->
    it 'parses Elixir AST into a JavaScript object', ->
      exAst = @translator.parse @source
      expect(exAst['name']).to.equal('defmodule')

