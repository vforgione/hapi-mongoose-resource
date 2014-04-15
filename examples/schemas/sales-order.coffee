###
  schema and model for sales orders
###

# mongoose requirements
mongoose = require 'mongoose'
Schema = mongoose.Schema

# reference requirements
Customer = require('./customer').Customer
Product = require('./product').Product


# schema
SalesOrderSchema = new Schema {
  customer: { type: Schema.Types.ObjectId, ref: Customer }
  products: [{ type: Schema.Types.ObjectId, ref: Product }]
}

SalesOrderSchema.virtual('total').get ->
  this.products.reduce (t, s) -> t.price + s.price


# model
SalesOrder = mongoose.model 'SalesOrder', SalesOrderSchema


module.exports = {
  SalesOrderSchema: SalesOrderSchema
  SalesOrder: SalesOrder
}
