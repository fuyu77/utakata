module.exports = {
  test: /bootstrap\.native/,
  use: {
    loader: "bootstrap.native-loader",
    options: {
      only: ["button", "dropdown", "tab", "toast"]
    }
  }
}
