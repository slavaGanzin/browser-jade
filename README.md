Compile jade into js functions served as one file

```
  $ jade2js path/to/templates path/to/result.js
  
```

in html:
```
  <script src=/templates.js/>
  <script>
    render.*YourTemplateFilename*(variables)
  </script>
```
