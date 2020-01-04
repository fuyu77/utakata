const { environment } = require('@rails/webpacker')
const bootstrapNative = require('./loaders/bootstrap_native')

environment.loaders.append('bootstrap.native', bootstrapNative)
module.exports = environment
