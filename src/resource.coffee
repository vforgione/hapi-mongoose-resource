
_ = require 'lodash'

Handler = require './handler'
Router = require './router'


class Resource

  constructor: (@model, @path, options) ->
    default_options = {
      resource_key: "_id"
    }

    @schema = schema
    @path = path

    # merge options -> overwrite default options with supplied options
    @options = {}
    _.merge(@options, default_options, options)

    # instantiate a handler
    @handler = new Handler @model, @path, @options

    # instantiate a router
    @router = new Router @path, @handler, @options


module.exports = Resource
