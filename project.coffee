FreeDrawTool = require "./free-draw-tool"
translate = require "t7e"

[apiHost, apiProxyPath] = if window.location.hostname is 'www.floatingforests.org'
  ['https://www.floatingforests.org', '/_ouroboros_api/proxy']
else
  [null, null]

module.exports =
  id: 'kelp'
  apiHost: apiHost
  apiProxyPath: apiProxyPath

  subjectGroup: true
  background: './images/kelp-bg.jpg'
  title: translate 'span', 'site.title'
  summary: translate 'span', 'site.summary'
  description: translate 'span', 'site.description'

  pages: [{
      key: 'about'
      title: 'About'
      content: require "./pages/about"
    },{
      key: 'education'
      title: "Education"
      content: require "./pages/education"
    },{
      key: 'team'
      title: "Team"
      content: require "./pages/team"
    }]

  tasks:
    pickOne:
      type: 'drawing',
      choices: [{
        type: FreeDrawTool,
        label: 'Default'
      }]
