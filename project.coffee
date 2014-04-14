#> zooniverse-readymade serve --css project.styl --js overrides.coffee
FreeDrawTool = require "./free-draw-tool"

module.exports =
  id: 'project_id'
  background: 'kelp-forest-large.jpg'
  title: 'Kelp Hunters'
  summary: 'We need your help to find Kelp'
  description: 'Click the classify button to get started'

  pages: [{
    'About': '''
      <h1>All about the project</h1>
      <p>This is where we\'ll go into detail.</p>
      <h2>Lorem ipsum dolor sir amet.</h2>
      <p>Break it into sections, add pictures, whatever.</p>
    '''
  }, {
    "Discuss": """
      <h1>Discuss Kelp</h1>
    """
  }]

  organizations: [{
    image: '//placehold.it/100.png?text=Example'
    name: 'Example Organization'
    description: 'This is an example organization.'
    url: ['https://www.zooniverse.org/', 'https://twitter.com/the_zooniverse', 'https://github.com/zooniverse']
  }]

  scientists: [{
    image: '//placehold.it/100.png?text=Example'
    name: 'Example Scientist'
    location: 'Oxford, U.K.'
    description: 'This is an example scientist.'
    url: 'https://twitter.com/orbitingfrog'
  }]

  developers: [{
    image: '//placehold.it/100.png?text=Example'
    name: 'Alex'
    location: 'Chicago, IL'
    description: 'This is an example developer.'
    url: ['https://aweiksnar.github.io', 'https://github.com/aweiksnar']
  }]

  tasks:
    pickOne:
      type: 'drawing',
      choices: [{
        value: FreeDrawTool,
        label: 'Default'
      }]
