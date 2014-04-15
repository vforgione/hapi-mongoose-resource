###
  schema and model for products
###

# mongoose requirements
mongoose = require 'mongoose'
Schema = mongoose.Schema


# schema
ProductSchema = new Schema {
  name: { type: String, required: true }
  number: { type: Number, unique: true, min: 0, required: true }
  price: { type: Number, min: 0, required: true }
  description: String
  tags: Schema.Types.Mixed
}


# model
Product = mongoose.model 'Product', ProductSchema


module.exports = {
  ProductSchema: ProductSchema
  Product: Product
}
