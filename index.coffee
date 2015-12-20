#!/usr/bin/coffee
watch = require 'watch'
jade = require 'jade'
fs = require 'fs'

files = []
compile = (buffer = []) ->
  buffer.push 'jade = {}'
  for f in files
    #TODO: collapses, proper function names
    name = f.replace(process.argv[2],'').replace(/^\//,'').replace(/.jade/,'').replace(/\//g,'"]["')
    buffer.push 'jade["'+name+'"] = '+ jade.compileFileClient f
  buffer.join('\n')

write = (content) ->
  fs.writeFileSync process.argv[3].replace(/(\.js)?$/,'.js') , content

watch.watchTree process.argv[2], (tree, curr, prev) ->
  for f,stat of tree
    files.push f if /\.jade$/.test f
  watch.unwatchTree process.argv[2]

watch.createMonitor process.argv[2], (monitor) ->
  for event in ['created', 'changed', 'removed']
    monitor.on event, (f, stat) ->
      console.log f + ' changed: ' + process.argv[3] + ' recompiled'
      write compile()
