module.exports = {
  plugins: ['tracking-schema'],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  overrides: [
    {
      files: ['docs/static/schemas/**/*.json'],
      parser: 'jsonc-eslint-parser',
      rules: {
        'tracking-schema/require-description': 'warn',
        'tracking-schema/require-type': 'error',
        'tracking-schema/require-examples': 'error',
      },
    },
    {
      files: ['docs/static/schemas/**/components/*.json'],
      rules: {
        'tracking-schema/require-examples': 'off',
      },
    },
  ],
};
