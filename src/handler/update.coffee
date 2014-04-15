
Boom = require 'boom'

resource_uri = require('./helpers').resource_uri
ref2resource = require('./helpers').ref2resource


module.exports = (Model, path, options) ->

  (req, res) ->

    Model.findOne req.params, (err, model) ->
      if err then return res Boom.notFound err.message
      model.set req.payload
      model.save (err) ->
        if err then return res Boom.notAcceptable err.message
        event = Model.modelName[0].toUpperCase() + Model.modelName.slice 1
        req.server.emit 'update' + event, model
        event = Model.collection.name[0].toUpperCase() + Model.collection.name.slice 1
        req.server.emit 'update' + event, model
        resource_uri model, path, options.resource_key
        ref2resource model, options.refs
        return res model
