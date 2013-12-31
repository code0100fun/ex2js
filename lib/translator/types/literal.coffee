class Literal
  constructor: (@raw) ->
    @value = if /".*"/.test(@raw) then @raw.match(/"(.*)"/)[1] else @raw
  ast: ->
      type: 'Literal'
      value: @value
      raw: @raw

module.exports = Literal
