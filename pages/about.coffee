translate = require 't7e'

module?.exports = "
  <div class='secondary-header'>
    #{translate 'h1', 'about.title'}
  </div>

  <div class='secondary-bg'>
    <div class='secondary-content'>
      <nav class='sub-nav-about'>
        #{translate 'button', 'about.overview.nav', name:'kelp'}
        #{translate 'button', 'about.task.nav', name: 'your-task'}
        #{translate 'button', 'about.goals.nav', name: 'goals'}
        #{translate 'a', 'about.results.nav', href:'http://blog.floatingforests.org'}
      </nav>
    </div>

    <div class='secondary-content'>
      <div class='left-column'>
        <div class='content sub-nav-about-kelp'>
          #{translate 'h1', 'about.overview.header'}
          #{translate 'p', 'about.overview.p1'}
          #{translate 'h1', 'about.overview.whyImportant'}
          #{translate 'p', 'about.overview.whyImportantP'}
        </div>

        <div class='content sub-nav-about-your-task'>
          #{translate 'h1', 'about.task.header'}
          #{translate 'p', 'about.task.p1'}
          #{translate 'h1', 'about.task.whyPublic'}
          #{translate 'p', 'about.task.whyPublicP'}
          #{translate 'h1', 'about.task.whatElse'}
          #{translate 'p', 'about.task.whatElseP'}
        </div>

        <div class='content sub-nav-about-goals'>
          #{translate 'h1', 'about.goals.whatLearn'}
          #{translate 'p', 'about.goals.whatLearnP'}
        </div>

        <div class='content sub-nav-about-results'>
          #{translate 'h1', 'about.results.header'}
          #{translate 'p', 'about.results.p1'}
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
