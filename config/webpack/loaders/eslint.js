module.exports = {
  test: /\.js$/,
  exclude: /node_modules/,
  loader: 'eslint-loader',
  enforce: 'pre',
  options: {}
}
