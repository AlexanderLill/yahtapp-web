const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  purge: {
    layers: ['components', 'utilities'],
    content:[
      './app/**/*.html.erb',
      './app/helpers/**/*.rb',
      './app/javascript/**/*.js',
      './app/javascript/**/*.vue',
      './app/javascript/**/*.jsx',
    ]
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        serif: ['QuincyCF','serif']
      },
      width: {
        small: '42rem',
        100: '28rem'
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [
      require('@tailwindcss/forms'),
      require('@tailwindcss/typography'),
      require('@tailwindcss/aspect-ratio')
  ],
}
