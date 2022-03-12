const path = require('path')
const webpack = require('webpack')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const RemoveEmptyScriptsPlugin = require('webpack-remove-empty-scripts')

module.exports = {
  mode: 'production',
  devtool: 'source-map',
  entry: {
    application: [
      './app/assets/javascripts/application.js',
      './app/assets/stylesheets/application.scss'
    ]
  },
  module: {
    rules: [
      {
        test: /\.(js)$/,
        exclude: /node_modules/,
        use: ['babel-loader']
      },
      {
        test: /\.s?[ac]ss$/i,
        use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader']
      }
    ]
  },
  output: {
    filename: '[name].js',
    sourceMapFilename: '[file].map[query]',
    path: path.resolve(__dirname, '..', '..', 'app/assets/builds')
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    }),
    new RemoveEmptyScriptsPlugin(),
    new MiniCssExtractPlugin()
  ],
  resolve: {
    extensions: ['.js', '.jsx', '.scss', '.css']
  }
}
