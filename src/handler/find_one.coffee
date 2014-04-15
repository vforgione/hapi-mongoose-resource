
Boom = require 'boom'

resource_uri = require('./helpers').resource_uri
ref2resource = require('./helpers').ref2resource


module.exports = (schema, path, options) ->

  (req, res) ->

    schema.findOne req.params, (err, model) ->
      if err then return res Boom.notFound err.message
      resource_uri model, path, options.resource_key
      ref2resource model, options.refs
      return res model
