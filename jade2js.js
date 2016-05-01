#!/usr/bin/node
global.ARGV = require('commander')
require('coffee-script/register')

ARGV
  .version('0.0.7')
  .usage ('path/to/templates path/to/result.js [options]')
  .option('-D, --no-debug', 'Generate files without debug hooks [production mode]')
  .action(function (path2templates, path2result, command) {
    global.path2templates = path2templates;
    global.path2result    = path2result.replace(/(\.js)?$/,'.js');
    
    if (process.argv.slice(2).length < 2) {
      ARGV.outputHelp();
      return process.exit(1);
    }
    
    require('./watch')();
  })
  .parse(process.argv)
