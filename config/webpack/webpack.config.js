const path = require('path');
const { globSync } = require('node:fs');
const webpack = require('webpack');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const RemoveEmptyScriptsPlugin = require('webpack-remove-empty-scripts');
const CompressionPlugin = require('compression-webpack-plugin');
const { PurgeCSSPlugin } = require('purgecss-webpack-plugin');

const PATHS = {
  src: path.join(__dirname, '../../app/views'),
};

module.exports = {
  mode: 'production',
  entry: {
    application: ['./app/assets/javascripts/application.js'],
  },
  module: {
    rules: [
      {
        test: /\.(js)$/,
        exclude: /node_modules/,
        use: ['babel-loader'],
      },
      {
        test: /\.s?[ac]ss$/i,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          {
            loader: 'sass-loader',
            options: {
              sassOptions: {
                quietDeps: true,
                silenceDeprecations: ['import'],
              },
            },
          },
        ],
      },
    ],
  },
  output: {
    filename: '[name].js',
    path: path.resolve(__dirname, '..', '..', 'app/assets/builds'),
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1,
    }),
    new RemoveEmptyScriptsPlugin(),
    new MiniCssExtractPlugin(),
    new PurgeCSSPlugin({
      paths: globSync('**/*', { cwd: PATHS.src, withFileTypes: true })
        .filter((entry) => entry.isFile())
        .map((entry) => path.join(entry.parentPath, entry.name)),
      safelist: ['tate', 'user_avatar'],
    }),
    new CompressionPlugin({
      test: /\.(js)|(s?[ac]ss)$/i,
    }),
  ],
  resolve: {
    extensions: ['.js', '.jsx', '.scss', '.css'],
  },
};
