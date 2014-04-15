
_ = require 'lodash'
Boom = require 'boom'

resource_uri = require('./helpers').resource_uri
ref2resource = require('./helpers').ref2resource


module.exports = (schema, path, options) ->

  (req, res) ->

    limit = req.query.limit || options.page_size
    skip = req.query.skip || undefined
    sort = req.query.sort || undefined

    query = _.merge req.query, req.params

    where = _.transform query , (conditions, value, key) ->
      if key not in ['limit', 'skip', 'sort']
        val = JSON.parse value
        if _.isObject val then conditions[key] = val
        else conditions[key] = value

    schema.find(where).sort(sort).skip(skip).limit(limit).exec (err, models) ->
      if err then return res Boom.badImplementation err.message
      for model in models
        resource_uri model, path, options.resource_key
        ref2resource model, options.refs
      return res models
