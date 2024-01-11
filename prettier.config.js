/** @type {import('prettier').Config} */
const prettierConfig = {
  semi: false,
  printWidth: 100,
  singleQuote: true,
  trailingComma: 'all',
  htmlWhitespaceSensitivity: 'ignore',
  plugins: ['@trivago/prettier-plugin-sort-imports', 'prettier-plugin-tailwindcss'],
  importOrder: [
    '^react$',
    '<THIRD_PARTY_MODULES>',
    '<TYPES>',
    '^@/(.*)$',
    '^[.]',
    '^(?!.*[.]css$)[./].*$',
    '.css$',
  ],
  importOrderSeparation: true,
  importOrderSortSpecifiers: true,
}

module.exports = prettierConfig
