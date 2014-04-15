
class Router

  constructor: (path, @handler, @options) ->
    # make paths
    resource_key = @options.resource_key
    single_path = "#{path}/{#{resource_key}}"

    # make routes
    @routes = [
      {
        method: "GET"
        path: single_path
        config: { handler: @handler.find_one() }
      }
      {
        method: "GET"
        path: path
        config: { handler: @handler.find() }
      }
      {
        method: "POST"
        path: path
        config: { handler: @handler.create() }
      }
      {
        method: "UPDATE"
        path: single_path
        config: { handler: @handler.update() }
      }
      {
        method: "DELETE"
        path: single_path
        config: { handler: @handler.destroy() }
      }
    ]


module.exports = Router
