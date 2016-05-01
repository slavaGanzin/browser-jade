Compile jade into js functions served as one file

```
  $ jade2js path/to/templates path/to/result.js [--no-debug]
  
```

in html:
```
  <script src=/templates.js/>
  <script>
    render.*YourTemplateFilename*(variables)
  </script>
```

All your script tags would be cut from jade template and moved into result.js file as [IIFE](https://en.wikipedia.org/wiki/Immediately-invoked_function_expression)
So you can use it to declare template specific code as:

```
  #myAwesomeSelector Hello World
  script
    - alert($('#myAwesomeSelector').val())
```

Jade generate a lot of debug information to help you debug your code. And it looks a bit messy, so for production use ```--no-debug``` or ```-D```
