import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "(my) dotfiles",
  description: "My personal dotfiles",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Overview', link: '/README' }
    ],
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
        text: 'Extra',
        items: [
          { text: 'Playground', link: '/playground' },
          { text: 'zshrc Graveyard', link: '/zshrc-graveyard' }
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/marcus-crane/dotfiles' }
    ]
  },
  sitemap: {
    hostname: "https://dotfiles.utf9k.net"
  }
})
