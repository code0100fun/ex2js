Identifier = require './types/identifier'

class AstBuilder
  astOrIdentifier: (obj) ->
    return null unless obj?
    if obj.constructor == Array
      obj.map (a) => @astOrIdentifier(a)
    else if typeof(obj) == 'object'
      obj.ast()
    else
      new Identifier(obj).ast()
  type: ->
    @constructor.name
  buildAst: (props...) ->
    ast = type: @type()
    for prop in props
      ast[prop] = @astOrIdentifier @[prop]
    ast


module.exports = AstBuilder
