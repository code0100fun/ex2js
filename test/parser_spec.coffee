Parser = require('../lib/parser/parser')
expect = require('chai').expect
fs = require 'fs'

describe 'Parser', () ->
  beforeEach ->
    @parser = new Parser()
    @source = fs.readFileSync('./fixtures/math.ex.ast').toString()
    @complexSource = fs.readFileSync('./fixtures/math2.ex.ast').toString()

  describe '#parse(source)', ->
    it 'parses Elixir AST into a JavaScript object', ->
      obj = @parser.parse @source
      expect(obj['name']).to.equal('defmodule')

    it 'parses a complex Elixir AST into a JavaScript object', ->
      obj = @parser.parse @complexSource
      expect(obj['name']).to.equal('defmodule')
      expect(obj.params[0].line).to.equal(1)
      expect(obj.params[1][0].aliases[0]).to.equal('Math2')
      doObj = obj.params[1][1].do
      expect(doObj).to.be.a('object')
      expect(doObj.block).to.be.a('array')
      expect(doObj.params[1]).to.be.a('array')
      defAdd = doObj.block[0]
      expect(defAdd.name).to.equal('def')
      expect(defAdd.params[1][0].name).to.equal('add')
      params = defAdd.params[1][0].params[1]
      expect(params[0].name).to.equal('a')
      expect(params[0].params[1]).to.equal(null)
      expect(params[1].name).to.equal('b')
      expect(params[1].params[1]).to.equal(null)
      defAddDo = defAdd.params[1][1].do.block
      expect(defAddDo[0].name).to.equal('=')
      params = defAddDo[0].params[1]
      expect(params[0].name).to.equal('ret')
      expect(params[0].params[1]).to.equal(null)
      expect(params[1].name).to.equal('+')
      expect(params[1].params[1][0].name).to.equal('a')
      expect(params[1].params[1][0].params[1]).to.equal(null)
      expect(params[1].params[1][1].name).to.equal('b')
      expect(params[1].params[1][1].params[1]).to.equal(null)
      expect(defAddDo[1].name).to.equal('ret')
      expect(defAddDo[1].params[1]).to.equal(null)
      # console.log '%j',  doObj.block
      defPower = doObj.block[1]
      expect(defPower.name).to.equal('def')
      expect(defPower.params[1][0].name).to.equal('square')
      params = defPower.params[1][0].params[1]
      expect(params[0].name).to.equal('a')
      expect(params[0].params[1]).to.equal(null)
      defPowerDo = defPower.params[1][1].do.block
      expect(defPowerDo[0].name).to.equal('=')
      params = defPowerDo[0].params[1]
      expect(params[0].name).to.equal('ret')
      expect(params[0].params[1]).to.equal(null)
      expect(params[1].name).to.equal('*')
      expect(params[1].params[1][0].name).to.equal('a')
      expect(params[1].params[1][0].params[1]).to.equal(null)
      expect(params[1].params[1][1].name).to.equal('a')
      expect(params[1].params[1][1].params[1]).to.equal(null)
      expect(defPowerDo[1].name).to.equal('ret')
      expect(defPowerDo[1].params[1]).to.equal(null)
      # console.log '%j', obj

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

    it 'extracts function object with function paramter', ->
      @parser.text = '{ \n :def , \n [ a : 1 ] ,\n [ { :b, [ a : 2 ], [] } ] \n },'
      @parser.reset()
      func = @parser.function()
      expect(func.params[1][0].name).to.equal('b')

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

  describe '#string()', ->
    it "gathers characters of a string", ->
      @parser.text = '"this is a test"]'
      @parser.reset()
      string = @parser.string()
      expect(string).to.equal('"this is a test"')

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

    it "recognizes '.' operator", ->
      @parser.text = ':.,'
      @parser.reset()
      atom = @parser.atom()
      expect(atom).to.equal('.')

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

    it 'extracts a do block parameter', ->
      @parser.text = '[do: {:__block__, [], [{:def, [], [] } ] } ],'
      @parser.reset()
      parameter = @parser.parameter()
      expect(Object.keys(parameter)[0]).to.equal('do')
      expect(parameter.do.name).to.equal('__block__')
      expect(parameter.do.params[0]).to.be.a('array')
      expect(parameter.do.params[1]).to.be.a('array')
      expect(parameter.do.block).to.be.a('array')
      expect(parameter.do.params[1][0].name).to.equal('def')
      expect(parameter.do.block[0].name).to.equal('def')
      expect(parameter.do.block[0].params[0]).to.be.a('array')
      expect(parameter.do.block).to.be.a('array')

  describe '#number()', ->
    it 'extracts a number', ->
      @parser.text = '1],'
      @parser.reset()
      number = @parser.number()
      expect(number).to.equal(1)

