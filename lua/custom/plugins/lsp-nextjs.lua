return {

  require('mason').setup {
    ensure_installed = {
      'tsserver',
      'tailwindcss-language-server',
      'eslint-language-server',
    },
  },
}
