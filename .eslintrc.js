module.exports = {
  parser: '@babel/eslint-parser',
  env: {
    browser: true,
    es6: true
  },
  extends: ['standard'],
  globals: {
    Atomics: 'readonly',
    SharedArrayBuffer: 'readonly'
  },
  parserOptions: {
    sourceType: 'module'
  },
  rules: {
    'space-before-function-paren': 'off'
  }
}
