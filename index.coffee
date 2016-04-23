watch = require 'watch'
jade = require 'jade'
fs = require 'fs'

if process.argv.length < 3
  console.log """Usage:
    $ jade2js path/to/templates path/to/result.js

    """
  return 1

separator = (name) ->
  "\n\n\n//#{name}   ####################################"
  
files = []
compile = (templates = [], scripts = []) ->
  templates.push 'render={}'
  for f in files
    #TODO: collapses, proper function names
    name = f.replace(process.argv[2],'')
            .replace(/^\//,'')
            .replace(/.jade/,'')
            .replace(/\//g,'"]["')
            
    file = fs.readFileSync(f).toString()
    file = file.replace /^script.*\n(^\s+.*\n)*/gim, (script) ->
      jade.compileClient script, compileDebug: false
          .replace /<script>(.*)<\/script>/gim, (withScriptTags, compiledScript)->
            scripts.push separator(f) + '\n' + compiledScript.replace /\\n/gim, "\n"
      ''
    try
      template = jade.compileClient file, compileDebug: false
      templates.push "render['#{name}'] = #{template}"
    catch e
      console.error message = "Error while compiling file #{f}\n\n#{e}\n\n"
      message = message.replace(/\n/gim, "\\n")
      templates.push "console.error(\"#{message}\")"
  
  [
    separator('runtime')
    fs.readFileSync('node_modules/jade/runtime.js').toString()
    separator('scripts')
    scripts.join '\n'
    separator('templates')
    templates.join '\n'
  ].join '\n'

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
