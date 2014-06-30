translate = require 't7e'

module?.exports = "
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
          <h1>#{translate 'about.overview.whyImportant'}</h1>
          <p>#{translate 'about.overview.whyImportantP'}</p>
        </div>

        <div class='content sub-nav-about-your-task'>
          <h1>#{translate 'about.task.header'}</h1>
          <p>#{translate 'about.task.p1'}</p>
          <h1>#{translate 'about.task.whyPublic'}</h1>
          <p>#{translate 'about.task.whyPublicP'}</p>
          <h1>#{translate 'about.task.whatElse'}</h1>
          <p>#{translate 'about.task.whatElseP'}</p>
        </div>

        <div class='content sub-nav-about-goals'>
          <h1>#{translate 'about.goals.whatLearn'}</h1>
          <p>#{translate 'about.goals.whatLearnP'}</p>
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