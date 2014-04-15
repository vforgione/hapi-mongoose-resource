
class Handler

  constructor: (@schema, @path, @options) ->

  find: ->
    return require('./find')(@schema, @path, @options)

  find_one: ->
    return require('./find_one')(@schema, @path, @options)

  create: ->
    return require('./create')(@schema, @path, @options)

  update: ->
    return require('./update')(@schema, @path, @options)

  destroy: ->
    return require('./destroy')(@schema, @path, @options)


module.exports = Handler
