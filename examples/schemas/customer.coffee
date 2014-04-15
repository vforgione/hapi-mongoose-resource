###
  schema and model for customers
###

# mongoose requirements
mongoose = require 'mongoose'
Schema = mongoose.Schema


# schema
CustomerSchema = new Schema {
  name: { type: String, required: true }
  email: { type: String, required: true }
  address: {
    street: { type: String, required: true }
    unit: String
    city: { type: String, required: true }
    state: { type: String, required: true }
    postal_code: { type: String, required: true }
    country: { type: String, default: 'United States', required: true }
  }
}


# model
Customer = mongoose.model 'Customer', CustomerSchema


module.exports = {
  CustomerSchema: CustomerSchema
  Customer: Customer
}
