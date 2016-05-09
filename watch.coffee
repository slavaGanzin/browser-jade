watch = require 'watch'
fs = require 'fs'
compile = require './compile'

module.exports = (files = []) ->
  write = (content) -> fs.writeFileSync path2result, content
  
  try
    fs.statSync path2templates
  catch e
    console.error "There is no '#{path2templates}' directory"
    return process.exit(1)
    
  watch.watchTree path2templates, (tree, curr, prev) ->
    for f,stat of tree
      files.push f if /\.jade$/.test f
    watch.unwatchTree path2templates
    write compile files
    console.log "Watching #{files.length} files: #{path2result} compiled"

  watch.createMonitor path2templates, (monitor) ->
    for event in ['created', 'changed', 'removed']
      monitor.on event, (f) ->
        write compile files
        console.log "#{f} #{event}: #{path2result} recompiled"
