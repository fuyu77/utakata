process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')
const webpack = require('webpack')
const ESLintPlugin = require('eslint-webpack-plugin')

environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    eslint_webpack_plugin: [new ESLintPlugin()]
  })
)
module.exports = environment.toWebpackConfig()
