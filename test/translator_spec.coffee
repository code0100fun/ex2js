Translator = require('../lib/translator')
JsAstInspector = require('../lib/js_ast_inspector')
expect = require('chai').expect
fs = require 'fs'

describe 'Translator', () ->
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
      debugger
      inspector = new JsAstInspector(jsAst)
      path = inspector.var('Math')
      debugger
      # expect(path.id.name).to.equal('Math')

    # it 'it converts defmodule to JavaScript module pattern', (done) ->
    #   jsAst = @translator.translate @source
    #   expect(jsAst.variables).to.include('Math')
    #   expect(jsAst['body'][0]['declarations'][0]['id']['name']).to.be.a('Math')
    #   done()

  describe '#parse(source)', ->
    it 'parses Elixir AST into a JavaScript object', ->
      exAst = @translator.parse @source
      expect(exAst['name']).to.equal('defmodule')
