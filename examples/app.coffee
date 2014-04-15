###
  entry point of application
###

# module imports
Hapi = require 'hapi'
mongoose = require 'mongoose'

Resource = require '../lib'


# connect to db
mongoose.connect 'mongodb://127.0.0.1:27017/hmrexample'


# instantiate server
server = new Hapi.createServer 'localhost', 3000, {}


# model imports
Product = require('./schemas/product').Product
Customer = require('./schemas/customer').Customer
SalesOrder = require('./schemas/sales-order').SalesOrder


# resources
ProductResource = new Resource Product, '/products'
CustomerResource = new Resource Customer, '/customers'
SalesOrderResource = new Resource SalesOrder, '/sales-orders', { refs: { customer: CustomerResource, products: ProductResource } }


# routing
server.route ProductResource.router.routes
server.route CustomerResource.router.routes
server.route SalesOrderResource.router.routes


# main loop
server.start ->
  console.log 'Server listening at ' + server.info.uri


###
  sample payloads to test:

  -- products --
  { "name": "T Shirt", "number": 12345, "price": 9.99, "description": "It's a T Shirt. Ta da!", "tags": { "color": "Blue", "size": "S", "style": "Girlie" } }
  { "name": "T Shirt", "number": 12350, "price": 9.99, "description": "It's a T Shirt. Ta da!", "tags": { "color": "Red", "size": "M" } }
  { "name": "T Shirt", "number": 12351, "price": 9.99, "description": "It's a T Shirt. Ta da!", "tags": { "color": "Green", "size": "M" } }

  -- customers --
  { "name": "Joe Chicago", "email": "joey.chitown@server.com", "address": { "street": "123 N State St", "unit": "321", "city": "Chicago", "state": "IL", "postal_code": "60602" } }
  { "name": "Jane Chicago", "email": "jane.chitown@server.com", "address": { "street": "123 N State St", "unit": "321", "city": "Chicago", "state": "IL", "postal_code": "60602" } }

  -- sales orders --
  ** ids will change with your testing **
  { "customer": "534c8e46aa65b5a70810bf05", "products": ["534c8e12aa65b5a70810bf03", "534c8e20aa65b5a70810bf04"] }
  { "customer": "534c8e53aa65b5a70810bf06", "products": ["534c8ce1250f948008b68cde"] }
###
