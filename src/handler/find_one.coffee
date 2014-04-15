
Boom = require 'boom'

resource_uri = require('./helpers').resource_uri
ref2resource = require('./helpers').ref2resource
omit_keys = require('./helpers').omit_keys
rename_keys = require('./helpers').rename_keys


module.exports = (Model, path, options) ->

  (req, res) ->

    Model.findOne req.params, (err, model) ->
      if err or model == null
        return res Boom.notFound req.params

      else
        resource_uri model, path, options.resource_key
        ref2resource model, options.refs
        omit_keys model, options.omit
        rename_keys model, options.rename

        return res model
