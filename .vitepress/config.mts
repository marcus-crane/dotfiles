import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "(my) dotfiles",
  description: "My personal dotfiles",
  head: [
    ['link', { rel: "apple-touch-icon", sizes: "180x180", href: "/apple-touch-icon.png"}],
    ['link', { rel: "icon", type: "image/png", sizes: "32x32", href: "/favicon-32x32.png"}],
    ['link', { rel: "icon", type: "image/png", sizes: "16x16", href: "/favicon-16x16.png"}],
    ['link', { rel: "manifest", href: "/site.webmanifest"}],
    ['link', { rel: "shortcut icon", href: "/favicon.ico"}],
  ],
  lastUpdated: true,
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Overview', link: '/README' }
    ],
    logo: '/android-chrome-192x192.png',
    editLink: {
      pattern: 'https://github.com/marcus-crane/dotfiles/edit/main/:path'
    },
    search: {
      provider: 'local'
    },
    sidebar: [
      {
        text: 'Start Here',
        items: [
          { text: 'Overview', link: '/README' }
        ]
      },
      {
        text: 'Files',
        items: [
          { text: '~/.sqliterc', link: '/sqliterc' },
          { text: '~/.ssh/authorized_keys', link: '/dot_ssh/authorized_keys' },
          { text: '~/.zshrc', link: '/zshrc' }
        ]
      },
      {
        text: 'Scripts',
        items: [
          { text: '01 Packages (macOS)', link: '/run_once_01_packages-darwin.sh.tmpl' }
        ]
      },
      {
        text: 'Extras',
        items: [
          { text: 'Playground', link: '/playground' },
          { text: 'zshrc Graveyard', link: '/zshrc-graveyard' }
        ]
      }
    ],
    footer: {
      message: 'Source code released under the <a href="https://github.com/marcus-crane/dotfiles/blob/main/LICENSE">MIT License</a>.',
      copyright: '<a href="https://www.svgrepo.com/svg/492995/server-and-people">Hero image</a> by <a href="https://soco-st.com">Soco St</a> used under the <a href="https://creativecommons.org/licenses/by/4.0/">CC Attribution License</a>.'
    },
    socialLinks: [
      { icon: 'github', link: 'https://github.com/marcus-crane/dotfiles' }
    ]
  },
  sitemap: {
    hostname: "https://dotfiles.utf9k.net"
  }
})
