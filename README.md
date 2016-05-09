Compile jade into js functions served as one file

```sh
  $ jade2js path/to/templates path/to/result.js [--no-debug]
```
```jade
  # path/to/templates/someContent.jade

  .content= content

```

in html:
```html
  <script src=/templates.js/>
  <script>
    document.getElementById('content').innerHtml=render.someContent({content: 'Hello World'})
  </script>
  <body>
    <div id='content'></div>
  </body>
```
You'll get:
```html
  ...
  <body>
    <div id='content'>
        <div class='content'>Hello World</div>
    </div>
  </body>
```

All your script tags would be cut from jade template and moved into result.js file as [IIFE](https://en.wikipedia.org/wiki/Immediately-invoked_function_expression)
So you can use it to declare template specific code as:

```jade
  #myAwesomeSelector Hello World
  script
    - alert($('#myAwesomeSelector').val())
```

Jade generate a lot of debug information to help you debug your code. And it looks a bit messy, so for production use ```--no-debug``` or ```-D```
