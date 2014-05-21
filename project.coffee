FreeDrawTool = require "./free-draw-tool"
translate = require "t7e"

module.exports =
  id: 'kelp'
  subjectGroup: true
  background: './images/kelp-forest-large.jpg'
  title: translate 'site.title'
  summary: translate 'site.summary'
  description: translate 'site.description'

  pages: [{
    'About': "
      <div class='secondary-header'>
        <h1>#{translate 'about.title'}</h1>
      </div>

      <div class='secondary-bg'>
        <div class='secondary-content'>
          <nav class='sub-nav-about'>
            <button name='kelp'>#{translate 'about.overview.nav'}</button>
            <button name='your-task'>#{translate 'about.task.nav'}</button>
            <button name='goals'>#{translate 'about.goals.nav'}</button>
            <button name='results'>#{translate 'about.results.nav'}</button>
          </nav>
        </div>

        <div class='secondary-content'>
          <div class='left-column'>
            <div class='content sub-nav-about-kelp'>
              <h1>#{translate 'about.overview.header'}</h1>
              <p>#{translate 'about.overview.p1'}</p>
              <p>#{translate 'about.overview.p2'}</p>
            </div>

            <div class='content sub-nav-about-your-task'>
              <h1>#{translate 'about.task.header'}</h1>
              <p>#{translate 'about.task.p1'}</p>
              <p>#{translate 'about.task.p2'}</p>
            </div>

            <div class='content sub-nav-about-goals'>
              <h1>#{translate 'about.goals.header'}</h1>
              <p>#{translate 'about.goals.p1'}</p>
            </div>

            <div class='content sub-nav-about-results'>
              <h1>#{translate 'about.results.header'}</h1>
              <p>#{translate 'about.results.p1'}</p>
            </div>
          </div>

          <div class='right-column'>
            <div class='content'>
              <h1>#{translate 'about.getInvolved.header'}</h1>
              <p>#{translate 'about.getInvolved.p1'}</p>
              <a href='#/classify'><button>#{translate 'about.getInvolved.callToAction'}</button></a>
              <h1>#{translate 'about.connect.header'}</h1>
              <p>#{translate 'about.connect.p1'}</p>
            </div>
          </div>
        </div>
      </div>
    "
  }]

  # organizations: [{
  #   image: '//placehold.it/100.png?text=Example'
  #   name: 'Example Organization'
  #   description: 'This is an example organization.'
  #   url: ['https://www.zooniverse.org/', 'https://twitter.com/the_zooniverse', 'https://github.com/zooniverse']
  # }]

  # scientists: [{
  #   image: '//placehold.it/100.png?text=Example'
  #   name: 'Example Scientist'
  #   location: 'Oxford, U.K.'
  #   description: 'This is an example scientist.'
  #   url: 'https://twitter.com/orbitingfrog'
  # }]

  # developers: [{
  #   image: '//placehold.it/100.png?text=Example'
  #   name: 'Alex'
  #   location: 'Chicago, IL'
  #   description: 'This is an example developer.'
  #   url: ['https://aweiksnar.github.io', 'https://github.com/aweiksnar']
  # }]

  tasks:
    pickOne:
      type: 'drawing',
      choices: [{
        type: FreeDrawTool,
        label: 'Default'
      }]
