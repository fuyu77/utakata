const path = require('path')
const webpack = require('webpack')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const RemoveEmptyScriptsPlugin = require('webpack-remove-empty-scripts')
const CompressionPlugin = require('compression-webpack-plugin')
const { globSync } = require('glob')
const { PurgeCSSPlugin } = require('purgecss-webpack-plugin')

const PATHS = {
  src: path.join(__dirname, '../../app/views')
}

module.exports = {
  mode: 'production',
  entry: {
    application: ['./app/assets/javascripts/application.js']
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
    path: path.resolve(__dirname, '..', '..', 'app/assets/builds')
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    }),
    new RemoveEmptyScriptsPlugin(),
    new MiniCssExtractPlugin(),
    new PurgeCSSPlugin({
      paths: globSync(`${PATHS.src}/**/*`, { nodir: true }),
      safelist: ['tate', 'user_avatar']
    }),
    new CompressionPlugin({
      test: /\.(js)|(s?[ac]ss)$/i
    })
  ],
  resolve: {
    extensions: ['.js', '.jsx', '.scss', '.css']
  }
}
