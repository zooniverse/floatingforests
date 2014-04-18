FreeDrawTool = require "./free-draw-tool"

module.exports =
  id: 'project_id'
  background: 'kelp-forest-large.jpg'
  title: 'Kelp Hunters'
  summary: 'Help find kelp forests'
  description: 'Join the search of satellite imagery to locate and track the worlds kelp forests!'

  pages: [{
    'About': '''
      <div class="secondary-header">
        <h1>About Kelp</h1>
      </div>

      <div class="secondary-bg">
        <div class="secondary-content">
          <nav class="sub-nav-about">
            <button name="kelp">Kelp</button>
            <button name="your-task">Your Task</button>
            <button name="goals">Goals</button>
            <button name="results">Results</button>
          </nav>
        </div>

        <div class="secondary-content">
          <div class="left-column">
            <div class="content sub-nav-about-kelp">
              <h1>Finding Kelp</h1>
              <p>
                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
              </p>

              <p>
                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
              </p>

              <p>
                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
              </p>

              <p>
                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
              </p>

            </div>

            <div class="content sub-nav-about-your-task">
              <h1>Your Task</h1>
              <p>This will be the your task section</p>
            </div>

            <div class="content sub-nav-about-goals">
              <h1>Goals</h1>
              <p>This will be the goals section</p>
            </div>

            <div class="content sub-nav-about-results">
              <h1>Results</h1>
              <p>This will be the results section</p>
            </div>
          </div>

          <div class="right-column">
            <div class="content">
              <h1>Get Involved</h1>
              <p>Join us in the hunt for Kelp. Are you ready?</p>
              <a href="#/classify"><button>Start Classifying</button></a>
              <h1>Connect</h1>
              <p>Follow the <a href="">Kelp Hunters</a> Blog and <a href="">@kelp_hunters</a> to keep current with the latest results</p>
            </div>
          </div>
        </div>
      </div>
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
