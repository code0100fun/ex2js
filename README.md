# ex2js [![Build Status](https://secure.travis-ci.org/code0100fun/ex2js.png?branch=master)](http://travis-ci.org/code0100fun/ex2js)

An Elixir AST to ECMAScript transpiler.

## Getting Started
Install the module with: `npm install ex2js`

```
var ex2js = require('ex2js');

// optional - look at parsed Elixir AST
var exAstJson = ex2js.parse(exAst);

// optional - look at the Elixir AST translated to a JavaScript AST
var jsAst = ex2js.translate(exAst);

// the normal use case is to just import the Elixir AST and compile/eval it
var js = ex2js.compile(exAst);
eval(js);
```

## Debugging
```
$ node debug $(which grunt)
debug > c
debug > repl
```

## Documentation
_(Coming soon)_

## Examples
_(Coming soon)_

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History
_(Nothing yet)_

## License
Copyright (c) 2013 Chase McCarthy and Johnny Winn. Licensed under the MIT license.
