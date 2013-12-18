Compiler = require('../lib/compiler')
expect = require('chai').expect
fs = require 'fs'

describe 'Compiler', () ->
  beforeEach ->
    @source = fs.readFileSync('./fixtures/math.ex.ast').toString()
    @compiler = new Compiler()
  
  write = (js) ->
    js = js.replace(/\n/g, '\r')
    fs.mkdirSync("./test/output") unless fs.existsSync "./test/output"
    fs.writeFile "./test/output/math.js", js, (e) ->

  describe '#compile(source)', ->
    it 'compiles Elixir AST into JavaScript', ->
      js = @compiler.compile(@source)
      write js
      expect(js).to.contain('var Math = function')

