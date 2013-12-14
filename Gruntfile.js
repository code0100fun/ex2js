'use strict';

module.exports = function (grunt) {
  require('time-grunt')(grunt);
  require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    mochaTest: {
      test: {
        src: ['test/**/*.coffee'],
        options: {
          compilers: 'coffee:coffee-script'
        }
      }
    }
  });

  grunt.registerTask('default', ['mochaTest']);
};
