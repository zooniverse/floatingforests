translate = require 't7e'

module?.exports = "
  <div class='secondary-header'>
    #{translate 'h1', 'education.title'}
  </div>

  <div class='secondary-bg'>
    <div class='secondary-content'>
      <nav class='sub-nav-education'>
        #{translate 'button', 'education.overview.nav', name: 'overview'}
        #{translate 'button', 'education.resources.nav', name: 'resources'}
        #{translate 'button', 'education.other.nav', name: 'other'}
      </nav>
    </div>

    <div class='secondary-content'>
      <div class='left-column'>
        <div class='content sub-nav-education-overview'>
          #{translate 'h1', 'education.overview.canIUse'}
          #{translate 'p', 'education.overview.canIUseP'}

          #{translate 'h1', 'education.overview.resources'}
          #{translate 'p', 'education.overview.resourcesP'}
        </div>

        <div class='content sub-nav-education-resources'>
          <h1><a href='https://www.youtube.com/watch?v=GcbU4bfkDA4'>#{translate 'span', 'education.resources.noaa'}</a></h1>
          <h1><a href='https://www.youtube.com/watch?v=vgYHUd5guf4'>#{translate 'span', 'education.resources.channelOnce'}</a></h1>
          <h1><a href='http://aquarium.ucsd.edu/Education/Learning_Resources/Voyager_for_Kids/kelpvoyager/'>#{translate 'span', 'education.resources.birch'}</a></h1>
          <h1><a href='http://montereybay.noaa.gov/sitechar/kelp.html'>#{translate 'span', 'education.resources.monterest'}</a></h1>
          <h1><a href='https://www.youtube.com/watch?v=eRfxFZ4ndlg'>#{translate 'span', 'education.resources.tasmania'}</a></h1>
          <h1><a href='http://education.zooniverse.org/'>#{translate 'span', 'education.resources.blog'}</a></h1>
        </div>

        <div class='content sub-nav-education-other'>
          <h1><a href='https://www.youtube.com/watch?v=HncMRSp8NNc'>#{translate 'span', 'education.other.octonauts'}</a></h1>
          <h1><a href='https://www.youtube.com/watch?v=ZRFPy9wpDgc'>#{translate 'span', 'education.other.octonauts2'}</a></h1>
          <h1><a href='https://www.youtube.com/watch?v=ZQb9ZFWfNZE'>#{translate 'span', 'education.other.tasmania'}</a></h1>
          <h1><a href='https://www.youtube.com/watch?v=BwIJvmBOj7s'>#{translate 'span', 'education.other.scuba'}</a></h1>
        </div>
      </div>

      <div class='right-column'>
        <div class='content'>
          #{translate 'h1', 'about.getInvolved.header'}
          #{translate 'p', 'about.getInvolved.p1'}
          <a href='#/classify'>#{translate 'button', 'about.getInvolved.callToAction'}</a>
          #{translate 'h1', 'about.connect.header'}
          #{translate 'p', 'about.connect.p1'}
        </div>
      </div>
    </div>
  </div>
"
