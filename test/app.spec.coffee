assert = require 'assert'
cake   = require 'coffee-script/lib/coffee-script/cake'
async  = require '../main'

describe 'async', ->

    it 'should register tasks normally', ->

        i = 0
        async task 't1', -> i++
        invoke 't1'
        assert.equal i, 1

    it 'should invoke a task asynchronously', (end) ->

        async task 't2', (o, done) ->
            done()
            end()

        invoke async 't2'

    it 'should preserve task context', (end) ->

        async task 't3', 'unicorns', (o, done) ->
            assert.equal @name, 't3'
            assert.equal @description, 'unicorns'
            done()
            end()

        invoke async 't3'

    it 'should preserve invocation order', (end) ->

        flag = off

        async task 't4', (o, done) ->
            assert.equal flag, off
            done()

        async task 't5', (o, done) ->
            flag = on
            done()

        invoke async 't4'
        invoke async 't5'

        async task 't6', (o, done) ->
            assert.equal flag, on
            end()

        invoke async 't6'

    it 'should be amazing', ->

        completed = []

        timer = (time) ->
            return (options, done) ->
                setTimeout =>
                    completed.push @name
                    done()
                , time

        async task 'one', timer 500
        async task 'two', timer 200
        async task 'three', timer 100
        async task 'four', timer 400

        task 'yeah', ->
            invoke async 'one'
            invoke async 'two'
            async.end =>
                completed.push @name

        task 'ok', ->
            invoke async 'three'
            invoke async 'four'
            async.end =>
                completed.push @name
                assert.deepEqual completed, [
                    'one'
                    'two'
                    'yeah'
                    'three'
                    'four'
                    'ok'
                ]

        invoke arg for arg in ['yeah', 'ok'] # equivalent to `cake yeah ok`


