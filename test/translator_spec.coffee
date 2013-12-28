Translator = require('../lib/translator')
JsAstInspector = require('../lib/js_ast_inspector')
expect = require('chai').expect
fs = require 'fs'

describe 'Translator', () ->

  _do = (block) ->
    block ?= {}
    block = fn('__block__', block...) if block.constructor == Array
    { do: block }

  fn = (name, params...) ->
    params = [{}, params] if params?
    { name: name, params: params }

  defmodule = (name, block) ->
    fn 'defmodule', fn('__aliases__', name), _do(block)

  def = (name, params, block) ->
    params = params.map((p)-> fn(p)) if params?
    func = if params then fn(name, params...) else fn(name)
    fn 'def', func, _do(block)

  addAst = fn '+', fn('a'), fn('b')

  assignAst = fn('=', fn('ret'), fn('+', fn('a'), fn('b')))

  defAddBlockAst = def('add', ['a','b'],[
      fn '=', fn('ret'), addAst
      fn('ret')
  ])

  beforeEach ->
    @source = fs.readFileSync('./fixtures/math.ex.ast').toString()
    @complexSource = fs.readFileSync('./fixtures/math2.ex.ast').toString()
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

    # it 'transplates a complex Elixir AST into JavaScript AST', ->
    #   jsAst = @translator.translate @complexSource
    #   inspector = new JsAstInspector(jsAst)
    #   path = inspector.var('Math')
    #   expect(path.id.name).to.equal('Math')

  describe '#statement(exAst)', ->
    it 'creates a module object when given an Elixir AST for a module', ->
      mod = @translator.statement defmodule('Foo')
      expect(mod.name).to.equal('Foo')

    it 'constructs a binary expression statement given the AST for an addition', ->
      add = @translator.statement addAst
      expect(add.expression.operator).to.equal('+')
      expect(add.expression.left).to.equal('a')
      expect(add.expression.right).to.equal('b')

    it 'constructs an assignment expression statemnt given the AST for an assignment', ->
      assign = @translator.statement assignAst
      expect(assign.expression.operator).to.equal('=')
      expect(assign.expression.left).to.equal('ret')
      expect(assign.expression.right).to.exist
      expect(assign.expression.right.operator).to.equal('+')

  describe '#method(exAst)', ->
    it 'constructs a method given the AST for a method', ->
      m = @translator.method def('bar')
      expect(m.name).to.equal('bar')

    it 'constructs a method given the AST for a method with a block', ->
      method = @translator.method defAddBlockAst
      expect(method.name).to.equal('add')
      expect(method.params[0]).to.equal('a')
      expect(method.params[1]).to.equal('b')
      expect(method.body.length).to.equal(2)
      expect(method.body[0].expression.operator).to.equal('=')
      expect(method.body[1].expression.name).to.equal('ret')

  describe '#module(exAst)', ->
    it 'constructs a module given the AST for a module', ->
      mod = @translator.module defmodule('Foo')
      expect(mod.name).to.equal('Foo')
      expect(mod.methods.length).to.equal(0)

  describe '#parse(source)', ->
    it 'parses Elixir AST into a JavaScript object', ->
      exAst = @translator.parse @source
      expect(exAst['name']).to.equal('defmodule')

