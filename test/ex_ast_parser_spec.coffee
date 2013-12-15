ExAstParser = require('../lib/ex_ast_parser')
expect = require('chai').expect
fs = require 'fs'

describe 'ExAstParser', () ->
  beforeEach ->
    @parser = new ExAstParser()
    @source = fs.readFileSync('./fixtures/math.ex.ast').toString()

  describe '#parse(source)', ->
    # it 'parses Elixir AST into JavaScript AST', (done) ->
    #   ast = @parser.parse @source
    #   # expect(ex2js.awesome()).to.equal('awesome')
    #   done()

    it 'parses Elixir AST into a JavaScript object', (done) ->
      obj = @parser.astToJson @source
      expect(obj['name']).to.equal('defmodule')
      done()

  describe '#reset()', ->
    it 'moves character pointer back to beginning and sets current character', ->
      @parser.text = 'abc'
      @parser.next()
      @parser.next()
      @parser.reset()
      expect(@parser.ch).to.equal('a')

  describe '#next()', ->
    it 'moves to next character', ->
      @parser.text = 'abc'
      @parser.reset()
      @parser.next()
      expect(@parser.ch).to.equal('b')

  describe '#white()', ->
    it 'moves character pointer past white space', ->
      @parser.text = '  ['
      @parser.reset()
      @parser.white()
      expect(@parser.ch).to.equal('[')

  describe '#function()', ->
    it 'extracts a parameter list containing a function', ->
      @parser.text = '[\n { \n :def , \n [ a : 1 ] ,\n [ :b ] \n }, [] \n]'
      @parser.reset()
      parameter = @parser.parameter()
      expect(parameter[0]['name']).to.equal('def')
      expect(parameter[0]['params'].length).to.equal(2)
      expect(parameter[0]['params'][0]['a']).to.equal(1)
      expect(parameter[0]['params'][1][0]).to.equal('b')

    it 'extracts function object with atom paramter', ->
      @parser.text = '{ \n :def , \n [ a : 1 ] ,\n [ :b ] \n },'
      @parser.reset()
      func = @parser.function()
      expect(func['name']).to.equal('def')
      expect(func['params'].length).to.equal(2)
      expect(func['params'][0]['a']).to.equal(1)
      expect(func['params'][1][0]).to.equal('b')

    it 'extracts function object with nil paramter', ->
      @parser.text = '{ \n :def , \n [ a : 1 ] ,\n nil \n },'
      @parser.reset()
      func = @parser.function()
      expect(func['params'][1]).to.equal(null)

    it 'extracts function object', ->
      @parser.text = '{ :def, [a:1], [b:2] },'
      @parser.reset()
      func = @parser.function()
      expect(func['name']).to.equal('def')
      expect(func['params'].length).to.equal(2)
      expect(func['params'][0]['a']).to.equal(1)
      expect(func['params'][1]['b']).to.equal(2)

    it 'extracts a function as a parameter of a function', ->
      @parser.text = "{:def,\n [a:1],\n [{\n :b,\n [c:2],\n [d:3]\n}]}"
      @parser.reset()
      func = @parser.function()
      expect(func['name']).to.equal('def')
      expect(func['params'].length).to.equal(2)
      expect(func['params'][0]['a']).to.equal(1)
      expect(func['params'][1][0]['name']).to.equal('b')

  describe '#atom()', ->
    it "gathers characters of an atom followed by a ','", ->
      @parser.text = ':def ,\n'
      @parser.reset()
      atom = @parser.atom()
      expect(atom).to.equal('def')

    it "gathers characters of an atom followed by a ']'", ->
      @parser.text = ':Math]'
      @parser.reset()
      atom = @parser.atom()
      expect(atom).to.equal('Math')

  describe '#parameterName()', ->
    it 'gathers characters of a parameter', ->
      @parser.text = 'do: {'
      @parser.reset()
      parameterName = @parser.parameterName()
      expect(parameterName).to.equal('do')

  describe '#parameter()', ->
    it 'extracts a parameter name and value', ->
      @parser.text = '[line: 1],'
      @parser.reset()
      parameter = @parser.parameter()
      expect(Object.keys(parameter)[0]).to.equal('line')
      expect(parameter['line']).to.equal(1)

  describe '#number()', ->
    it 'extracts a number', ->
      @parser.text = '1],'
      @parser.reset()
      number = @parser.number()
      expect(number).to.equal(1)

