class ExAstParser
  ch: ' '
  at: 0
  text: undefined
  symbol: ''
  parse: (source) ->

  reset: ->
    @at = 0
    @ch = @text.charAt @at

  onWhitespace: ->
    /\s/.test(@ch)

  next: ->
    @at += 1
    @ch = @text.charAt @at

  white: ->
    while @onWhitespace()
      @next()

  atom: ->
    @symbol = ''
    while(@ch && @ch != ',' && @ch != ']' && !@onWhitespace())
      @symbol += @ch
      @next()
    @symbol

  nil: ->
    @symbol = ''
    while(@ch && @ch != ',' && @ch != ']' && !@onWhitespace())
      @symbol += @ch
      @next()
    null if @symbol == 'nil'

  number: ->
    @symbol = ''
    while(@ch && @ch != ',' && @ch != ']')
      @symbol += @ch
      @next()
    parseInt(@symbol,10)

  parameterName: ->
    @symbol = ''
    while(@ch && @ch != ':' && !@onWhitespace())
      @symbol += @ch
      @next()
    @symbol

  paramsHash: ->
    param = {}
    while @ch && @ch != ']'
      key = @parameterName()
      @white()
      # move past ':'
      @next()
      value = @value()
      param[key] = value
      @white()
      @next() if @ch == ','
      @white()
    param

  paramsArray: ->
    param = []
    while @ch && @ch != ']'
      value = @value()
      param.push value
      @white()
      @next() if @ch == ','
      @white()
    @white()
    param

  parameter: ->
    # move past '['
    @next()
    @white()
    if @ch == 'n'
      @nil()
    else if @ch == '{' || @ch == ':'
      param = @paramsArray()
    else
      param = @paramsHash()
    # move past ']'
    @white()
    @next()
    @white()
    param

  function: ->
    # move past '{'
    @next()
    @white()
    funcName = @atom()
    @white()
    # move past ','
    @next()
    @white()
    param1 = @value()
    @white()
    # move past ','
    @next()
    @white()
    param2 = @value()
    @white()
    # move past '}'
    @next()
    @white()
    { name: funcName, params: [ param1, param2 ] }

  value: ->
    @white()
    value = switch @ch
      when '{' then @function()
      when '[' then @parameter()
      when ':' then @atom()
      when 'n' then @nil()
      else @number()
    value

  astToJson: (source) ->
    @text = source
    @reset()
    result = @value()
    # console.log 'Input: %j', @text
    # console.log 'Output: %j', result

module.exports = ExAstParser
