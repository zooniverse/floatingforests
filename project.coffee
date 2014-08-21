FreeDrawTool = require "./free-draw-tool"
translate = require "t7e"

module.exports =
  id: 'kelp'
  subjectGroup: true
  background: './images/kelp-bg.jpg'
  title: translate 'site.title'
  summary: translate 'site.summary'
  description: translate 'site.description'

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
