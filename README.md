cake-async
==========

Asynchronous cakefile tasks.

Simply add the `async` keyword before a `task` definition, and call the `done` callback once finished.

To run async tasks, use `invoke async 'task_name'` - there are no callbacks, instead invocations are queued and guaranteed to run in order within a task.

The function given to `async.end()` will be called when all tasks have finished.

#### Without

```coffeescript
task 'compile', ->
    compileAsync files

task 'minify', ->
    minifyAsync files

task 'build', ->
    invoke 'compile'
    invoke 'minify'
    # might or might not work depending on your luck
```

#### With cake-async

```coffeescript
async task 'compile', (o, done) ->
    compileAsync files, done

async task 'minify', (o, done) ->
    minifyAsync files, done

task 'build', ->
    invoke async 'compile'
    invoke async 'minify'
    async.end => console.log 'done!'
```

Tests
-----

```bash
npm install
npm install mocha -g # skip if you already have it
./mocha
```