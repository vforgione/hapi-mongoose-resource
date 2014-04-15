
class Handler

  constructor: (@model, @path, @options) ->

  find: ->
    return require('./find')(@model, @path, @options)

  find_one: ->
    return require('./find_one')(@model, @path, @options)

  create: ->
    return require('./create')(@model, @path, @options)

  update: ->
    return require('./update')(@model, @path, @options)

  destroy: ->
    return require('./destroy')(@model, @path, @options)


module.exports = Handler
