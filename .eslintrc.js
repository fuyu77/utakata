module.exports = {
  env: {
    browser: true,
    node: true,
    es2022: true,
  },
  extends: ['xo-space', 'prettier'],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
};
