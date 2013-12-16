Translator = require('../lib/translator')
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

  describe '#parse(source)', ->
    it 'parses Elixir AST into a JavaScript object', (done) ->
      exAst = @translator.parse @source
      expect(exAst['name']).to.equal('defmodule')
      done()
