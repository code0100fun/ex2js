JsAstInspector = require('./js_ast_inspector')
expect = require('chai').expect
fs = require 'fs'

describe 'JsAstInspector', () ->
  beforeEach ->
    @ast = JSON.parse fs.readFileSync('./fixtures/math.js.ast').toString()
    @inspector = new JsAstInspector(@ast)

  describe '#var(name)', ->
    it 'finds a variable by name', ->
      path = @inspector.var('Math')
      expect(path.id.name).to.equal('Math')

  describe '#func(name)', ->
    it 'finds a function by name', ->
      path = @inspector.func('add')
      expect(path.params[0].name).to.equal('a')
      expect(path.params[1].name).to.equal('b')

  describe '#anonymousFunc()', ->
    it 'finds the first anonymous function from the root context', ->
      path = @inspector.anonymousFunc()
      expect(path.type).to.equal('FunctionExpression')
      expect(path.params.length).to.equal(1)
