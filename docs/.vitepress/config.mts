import { defineConfig } from 'vitepress'
import { withMermaid } from "vitepress-plugin-mermaid";

// https://vitepress.dev/reference/site-config
export default withMermaid(defineConfig({
  title: "DataSanitizer",
  description: "A PowerShell module for identifying, and sanitizing personal and sensitive data",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'User Guide', link: '/user/whath-is-datasanitizer' },
      { text: 'Developer Guide', link: '/developer/developer-guide' },
      { text: 'Changelog', link: 'https://github.com/fslef/DataSanitizer/blob/main/CHANGELOG.md' }
    ],

    sidebar: {
      '/user/': [
        {
          text: 'User Guide',
          items: [
            { text: 'Index', link: '/user/' },
            { text: 'One', link: '/user/one' },
            { text: 'Two', link: '/user/two' }
          ]
        }
      ],
      '/developer/': [
        {
          text: 'Developer Guide',
          items: [
            { text: 'Overview', link: '/developer/developer-guide' },
            { text: 'Introduction', link: '/developer/introduction' },
            { text: 'Workflow', link: '/developer/development-workflow' },
            { text: 'Environment Setup', link: '/developer/environment-setup' },
            { text: 'Coding Standards', link: '/developer/coding-standards' },
            { text: 'Testing', link: '/developer/testing' },
            { text: 'Documentation', link: '/developer/documentation' },
            { text: 'Releasing', link: '/developer/releasing' },
            { text: 'Troubleshooting & FAQ', link: '/developer/troubleshooting-faq' },
            { text: 'Contributing', link: '/developer/contributing' }
          ]
        }
      ]
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/fslef/DataSanitizer' }
    ]
  },
  mermaid: {
    // refer https://mermaid.js.org/config/setup/modules/mermaidAPI.html#mermaidapi-configuration-defaults for options
  },
  mermaidPlugin: {
    class: "mermaid my-class"
  }
}))