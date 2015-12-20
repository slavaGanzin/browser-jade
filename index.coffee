watch = require 'watch'
jade = require 'jade'
fs = require 'fs'

files = []
compile = (buffer = []) ->
  buffer.push 't = {}'
  for f in files
    #TODO: collapses, proper function names
    name = f.replace(/.jade/,'').replace('/','"]["')
    buffer.push 't["'+name+'"] = '+ jade.compileFileClient f
  buffer.join('\n')


write = (content) ->
  fs.writeFileSync process.argv[3].replace(/(\.js)?$/,'.js') , content

watch.watchTree process.argv[2], (tree, curr, prev) ->
  for f,stat of tree
    files.push f if /\.jade$/.test f
  watch.unwatchTree process.argv[2]

watch.createMonitor process.argv[2], (monitor) ->
  monitor.on 'created', (f, stat) -> write compile()
  monitor.on 'changed', (f, curr, prev) -> write compile()
  monitor.on 'removed', (f, stat) -> write compile()
