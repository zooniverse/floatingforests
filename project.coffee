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
    {'About': require "./secondary-pages/about"},
    {"Education": require "./secondary-pages/education"},
    {"Team": require "./secondary-pages/team"}
  ]

  tasks:
    pickOne:
      type: 'drawing',
      choices: [{
        type: FreeDrawTool,
        label: 'Default'
      }]
