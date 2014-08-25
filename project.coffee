FreeDrawTool = require "./free-draw-tool"
translate = require "t7e"

module.exports =
  id: 'kelp'
  subjectGroup: true
  background: './images/kelp-bg.jpg'
  title: translate 'span', 'site.title'
  summary: translate 'span', 'site.summary'
  description: translate 'span', 'site.description'

  pages: [
    {'About': require "./pages/about"},
    {"Education": require "./pages/education"},
    {"Team": require "./pages/team"}
  ]

  tasks:
    pickOne:
      type: 'drawing',
      choices: [{
        type: FreeDrawTool,
        label: 'Default'
      }]
