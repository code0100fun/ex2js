'use strict';

module.exports = function (grunt) {
  require('time-grunt')(grunt);
  require('load-grunt-tasks')(grunt);

  grunt.loadNpmTasks('grunt-shell');

  grunt.initConfig({
    mochaTest: {
      test: {
        src: ['test/**/*.coffee'],
        options: {
          reporter : 'spec',
          compilers: 'coffee:coffee-script'
        }
      }
    },
    shell: {
      pry: {
        command: 'node debug $(which grunt)',
        options: {
          stdout: true
        }
      }
    }
  });

  grunt.registerTask('default', 'mochaTest');
};
