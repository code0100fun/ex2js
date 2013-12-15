class ExAstParser
  ch: ' '
  at: 0
  text: undefined
  parse: (source) ->

  reset: ->
    @at = 0
    @ch = @text.charAt @at

  onWhitespace: ->
    /\s/.test(@ch)

  around: ->
    @text.substring(@at - 10, @at + 10)

  next: ->
    @at += 1
    @ch = @text.charAt @at

  nextChar: (ch) ->
    @white()
    if ch && ch != @ch
      # TODO - throw exception
      console.log("Error: expected '#{ch}' but found '#{@ch}' around '#{@around()}'")
    @next()
    @white()

  white: ->
    while @onWhitespace()
      @next()

  word: (pattern) ->
    word = ''
    while(@ch && pattern.test(@ch))
      word += @ch
      @next()
    word

  atom: ->
    # TODO - handle non-word characters in atoms ('-', '=',...)
    atom = @word(/\+|:|\w/)
    atom.replace ':', ''

  nil: ->
    @word(/[nil]/)
    null

  number: ->
    num = @word(/\d/)
    parseInt(num,10)

  parameterName: ->
    @word(/\w/)

  loopUntil: (ch, block) ->
    while @ch && @ch != ch
      block(@value())
      @white()
      @next(',') if @ch == ','
      @white()

  keyValue: ->
    key = @parameterName()
    @nextChar(':')
    value = @value()
    param = {}
    param[key] = value
    param

  paramsHash: ->
    params = {}
    @loopUntil ']', (value) =>
      @merge params, value
    @white()
    params

  paramsArray: ->
    params = []
    @loopUntil ']', (value) ->
      params.push value
    @white()
    params

  parameter: ->
    @nextChar('[')
    if @ch == '{' || @ch == ':'
      param = @paramsArray()
    else
      param = @paramsHash()
    @nextChar(']')
    param

  function: ->
    @nextChar('{')
    funcName = @atom()
    @nextChar(',')
    param1 = @value()
    @nextChar(',')
    param2 = @value()
    @nextChar('}')
    { name: funcName, params: [ param1, param2 ] }

  value: ->
    @white()
    value = switch @ch
      when '{' then @function()
      when '[' then @parameter()
      when ':' then @atom()
      when 'n' then @nil()
      else
        if /\d/.test(@ch)
          @number()
        else
          @keyValue()
    value

  astToJson: (source) ->
    @text = source
    @reset()
    result = @value()

  merge: (dest, objs...) ->
    for obj in objs
      dest[k] = v for k, v of obj
      dest

module.exports = ExAstParser
