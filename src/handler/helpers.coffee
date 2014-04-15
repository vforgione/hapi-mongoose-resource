
isArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'


module.exports = {

  ref2resource: (model, refs) ->
    for key, resource of refs
      if isArray model[key]
        for i, val of model[key]
          model._doc[key][i] = resource.path + '/' + val
      else
        model._doc[key] = resource.path + '/' + model[key]

  resource_uri: (model, path, resource_key) ->
    model._doc.resource_uri = path + '/' + model[resource_key]

  omit_keys: (model, omit) ->
    for key in omit
      delete model._doc[key]

  rename_keys: (model, rename) ->
    for old_key, new_key of rename
      model._doc[new_key] = model._doc[old_key]
      delete model._doc[old_key]

}
