/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */

// @ts-check

/** @type {import('@docusaurus/plugin-content-docs').SidebarsConfig} */
const sidebars = {

  filesSidebar: [
    {
      type: 'doc',
      id: 'intro',
      label: 'README'
    },
    {
      type: 'category',
      label: 'Home Directory',
      collapsible: true,
      collapsed: false,
      items: [
        {
          type: 'category',
          label: '.ssh',
          collapsible: true,
          collapsed: true,
          items: [
            'home/ssh/authorized_keys'
          ]
        },
        {
          type: 'doc',
          id: 'home/sqliterc',
          label: '.sqliterc'
        },
        {
          type: 'doc',
          id: 'home/zshrc',
          label: '.zshrc'
        }
      ]
    },
    {
      type: 'category',
      label: 'Extras',
      items: [
        'extras/playground',
        'extras/zshrc-graveyard'
      ]
    }
  ]

  // But you can create a sidebar manually
  /*
  tutorialSidebar: [
    'intro',
    'hello',
    {
      type: 'category',
      label: 'Tutorial',
      items: ['tutorial-basics/create-a-document'],
    },
  ],
   */
};

module.exports = sidebars;
