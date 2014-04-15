
_ = require 'lodash'
Boom = require 'boom'

resource_uri = require('./helpers').resource_uri
ref2resource = require('./helpers').ref2resource


module.exports = (Model, path, options) ->

  (req, res) ->

    limit = req.query.limit || options.page_size
    skip = req.query.skip || undefined
    sort = req.query.sort || undefined

    limit = parseInt limit
    if skip? then skip = parseInt skip

    query = _.merge req.query, req.params

    where = _.transform query , (conditions, value, key) ->
      if key not in ['limit', 'skip', 'sort']
        val = JSON.parse value
        if _.isObject val then conditions[key] = val
        else conditions[key] = value

    Model.find(where).sort(sort).skip(skip).limit(limit).exec (err, models) ->
      if err then return res Boom.badImplementation err.message

      for model in models
        resource_uri model, path, options.resource_key
        ref2resource model, options.refs

      output = {}
      output.meta = {}
      output.meta.page_size = limit

      count = 0
      Model.count where, (err, count) ->
        if err then return res Boom.badImplementation err.message
        output.meta.total_count = count

        # next page
        if count > limit and count > skip + limit
          if skip? then new_skip = skip + limit
          else new_skip = limit
          next = path + "?"
          if sort
            next += "sort=" + sort + "&"
          next += "skip=" + new_skip + "&limit=" + limit
        else next = null
        output.meta.next = next

        # previous page
        if skip? and skip != 0
          if (skip - limit) < 0 then new_skip = 0
          else new_skip = skip - limit
          prev = path + "?"
          if sort
            prev += "sort=" + sort + "&"
          prev += "skip=" + new_skip + "&limit=" + limit
        else prev = null
        output.meta.previous = prev

        output.objects = models

        return res output
