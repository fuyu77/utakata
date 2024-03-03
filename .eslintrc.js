module.exports = {
  env: {
    browser: true,
    node: true,
    es2022: true,
  },
  extends: ['xo', 'prettier'],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
};
