jade = require 'jade'
fs = require 'fs'

separator = (name) ->
  "\n\n\n//#{name}   ####################################"
  

module.exports = (files = []) ->
  do (scripts = []) ->
    reportError = (e) ->
      console.error message = "Error while compiling file #{f}\n\n#{e}\n\n"
      message = message.replace(/\n/gim, "\\n")
      "console.error(\"#{message}\")"
    
    
    cutScripts = (file) ->
      file.replace /^script.*\n(^\s+.*\n)*/gim, (script) ->
        try
          jade.compileClient script, compileDebug: false
            .replace /<script>(.*)<\/script>/gim, (_, compiledScript)->
              scripts.push separator f
              scripts.push(compiledScript
                .replace /\\n/gim, "\n"
                .replace /\\\\/gim, "\\"
              )
        catch e
          reportError e
        ''
        
    templates = (for f in files
      onlyJade = cutScripts fs.readFileSync(f).toString()
        
      try
        templateName = f.replace(path2templates,'')
                .replace(/^\//,'')
                .replace(/.jade/,'')
                .replace(/\//g,'"]["')
        
        template = jade.compileClient onlyJade, compileDebug: ARGV.debug
        "render['#{templateName}'] = #{template}"
      catch e
        reportError e)
        
    [
      separator('runtime')
      fs.readFileSync('node_modules/jade/runtime.js').toString()
      separator('scripts')
      scripts.join '\n'
      separator('templates')
      "render={}"
      templates.join '\n'
    ].join '\n'
