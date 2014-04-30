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
            <button name="kelp">Overview</button>
            <button name="your-task">Your Task</button>
            <button name="goals">Goals</button>
            <button name="results">Results</button>
          </nav>
        </div>

        <div class="secondary-content">
          <div class="left-column">
            <div class="content sub-nav-about-kelp">
              <h1>Kelp Overview</h1>
              <p>Giant kelp forests produce a dense floating canopy that is clearly visible on Landsat satellite imagery. Landsat Thematic Mapper (TM) imagery is freely available to the public and provides global coverage every ~16 days from 1984-present. By providing classifications of changes in kelp canopy cover over the past 30 years on global scales, this project will identify regions where kelp forests have experience significant long-term changes. We will then identify the likely environmental and anthropogenic drivers of these observed changes.</p>
              <p>There is currently no long-term data on kelp canopy changes for most of the globe, so obtaining reliable classifications for any region (South Africa, Tasmania, New Zealand), would be a substantial improvement over our current data. Our ultimate goal would be to obtain global coverage over the entire Landsat TM time series (1984-present).</p>
            </div>

            <div class="content sub-nav-about-your-task">
              <h1>What is your task?</h1>
              <p>You are asked to trace the outline of giant kelp forests on Landsat satellite imagery. Kelp forests are highly distinctive on these images and we believe that by showing a few images of example forests, you will be able to identify forests without any specialist knowledge.</p>
              <p>There are currently many automated processing routines available for classifying satellite imagery. We have experimented with many of these, however they are not well suited for the nearshore coastal environment. Landsat was developed for terrestrial vegetation. The signal from floating aquatic vegetation is much weaker than that of terrestrial vegetation, and so we are working on the edge of Landsat’s signal to noise capabilities. High variability in nearshore conditions (e.g. clouds, sunglint, turbidity) complicates the situation. All of the automated processing routines we have used require extensive manual editing to produce an acceptable product.</p>
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
    "Feedback": """
      <iframe id='feedback' frameborder='0' src="https://docs.google.com/a/zooniverse.org/forms/d/1gfpaTZ-kS3UefF5CpRlfEQwv4s9rIBPY18PZyBZcCfw/viewform"></iframe>
    """
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
