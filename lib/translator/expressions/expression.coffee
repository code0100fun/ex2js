Identifier = require '../types/identifier'

class Expression
  astOrIdentifier: (obj) ->
    if obj.constructor == Array
      obj.map (a) => @astOrIdentifier(a)
    else if typeof(obj) == 'object'
      obj.ast()
    else
      new Identifier(obj).ast()

module.exports = Expression
