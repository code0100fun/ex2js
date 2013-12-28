class Identifier
  constructor: (@name) ->
  ast: ->
      type: 'Identifier'
      name: @name

module.exports = Identifier
