watch = require 'watch'
jade = require 'jade'
fs = require 'fs'

if process.argv.length < 3
  console.log """Usage:
    $ jade2js path/to/templates path/to/result.js

    """
  return 1

files = []
compile = (buffer = []) ->
  buffer.push fs.readFileSync('node_modules/jade/runtime.js').toString()
  buffer.push '//##########################################templates###########'
  buffer.push 'render={}'
  for f in files
    #TODO: collapses, proper function names
    name = f.replace(process.argv[2],'').replace(/^\//,'').replace(/.jade/,'').replace(/\//g,'"]["')
    buffer.push 'render["'+name+'"] = '+ jade.compileFileClient f
  buffer.join('\n')

write = (content) ->
  fs.writeFileSync process.argv[3].replace(/(\.js)?$/,'.js') , content

watch.watchTree process.argv[2], (tree, curr, prev) ->
  for f,stat of tree
    files.push f if /\.jade$/.test f
  watch.unwatchTree process.argv[2]
  console.log "Watching #{files.length} files"
  write compile()

watch.createMonitor process.argv[2], (monitor) ->
  for event in ['created', 'changed', 'removed']
    monitor.on event, (f, stat) ->
      console.log f + ' changed: ' + process.argv[3] + ' recompiled'
      write compile()
