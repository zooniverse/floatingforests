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
  },{
    "Education": "
      <div class='secondary-header'>
        <h1>#{translate 'education.title'}</h1>
      </div>

      <div class='secondary-bg'>
        <div class='secondary-content'>
          <nav class='sub-nav-education'>
            <button name='overview'>#{translate 'education.overview.nav'}</button>
            <button name='resources'>#{translate 'education.resources.nav'}</button>
            <button name='other'>#{translate 'education.other.nav'}</button>
          </nav>
        </div>

        <div class='secondary-content'>
          <div class='left-column'>
            <div class='content sub-nav-education-overview'>
              <h1>#{translate 'education.overview.canIUse'}</h1>
              <p>#{translate 'education.overview.canIUseP'}</p>

              <h1>#{translate 'education.overview.resources'}</h1>
              <p>#{translate 'education.overview.resourcesP'}</p>
            </div>

            <div class='content sub-nav-education-resources'>
              <h1><a href='https://www.youtube.com/watch?v=GcbU4bfkDA4'>#{translate 'education.resources.noaa'}</a></h1>
              <h1><a href='https://www.youtube.com/watch?v=vgYHUd5guf4'>#{translate 'education.resources.channelOnce'}</a></h1>
              <h1><a href='http://aquarium.ucsd.edu/Education/Learning_Resources/Voyager_for_Kids/kelpvoyager/'>#{translate 'education.resources.birch'}</a></h1>
              <h1><a href='http://montereybay.noaa.gov/sitechar/kelp.html'>#{translate 'education.resources.monterest'}</a></h1>
              <h1><a href='https://www.youtube.com/watch?v=eRfxFZ4ndlg'>#{translate 'education.resources.tasmania'}</a></h1>
            </div>

            <div class='content sub-nav-education-other'>
              <h1><a href='https://www.youtube.com/watch?v=HncMRSp8NNc'>#{translate 'education.other.octonauts'}</a></h1>
              <h1><a href='https://www.youtube.com/watch?v=ZRFPy9wpDgc'>#{translate 'education.other.octonauts2'}</a></h1>
              <h1><a href='https://www.youtube.com/watch?v=ZQb9ZFWfNZE'>#{translate 'education.other.tasmania'}</a></h1>
              <h1><a href='https://www.youtube.com/watch?v=BwIJvmBOj7s'>#{translate 'education.other.scuba'}</a></h1>
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
  },{
    "Team": "
      <div class='secondary-header'>
        <h1>#{translate 'team.title'}</h1>
      </div>

      <div class='secondary-bg'>
        <div class='secondary-content'>
          <nav class='sub-nav-team'>
            <button name='organizations'>#{translate 'team.organizations.nav'}</button>
            <button name='scientists'>#{translate 'team.scientists.nav'}</button>
            <button name='developers'>#{translate 'team.developers.nav'}</button>
          </nav>
        </div>
        <div class='secondary-content'>
          <div class='left-column'>
            <div class='content sub-nav-team-organizations'>
              <div class='team-member'>
                <h1>#{translate 'team.organizations.keen.name'}</h1>
                <img src='./images/team/keen.jpg'>
                <p>#{translate 'team.organizations.keen.description'}</p>
              </div>

              <div class='team-member'>
                <h1>#{translate 'team.organizations.santaBarbara.name'}</h1>
                <img src='./images/team/nceas.png'>
                <p>#{translate 'team.organizations.santaBarbara.description'}</p>
              </div>

              <div class='team-member'>
                <h1>#{translate 'team.organizations.nceas.name'}</h1>
                <img src='./images/team/sbclternet.jpg'>
                <p>#{translate 'team.organizations.nceas.description'}</p>
              </div>
            </div>

            <div class='content sub-nav-team-scientists'>

              <div class='team-member'>
                <h1>#{translate 'team.scientists.kyle.name'}</h1>
                <img src='./images/team/face_pic.jpg'>
                <p>#{translate 'team.scientists.kyle.description'}</p>
              </div>

              <div class='team-member'>
                <h1>#{translate 'team.scientists.jarrett.name'}</h1>
                <img src='./images/team/jarrett.jpg'>
                <p>#{translate 'team.scientists.jarrett.description'}</p>
              </div>

              <div class='team-member'>
                <h1>#{translate 'team.scientists.alejandro.name'}</h1>
                <img src='./images/team/alejandro.jpg'>
                <p>#{translate 'team.scientists.alejandro.description'}</p>
              </div>

              <div class='team-member'>
                <h1>#{translate 'team.scientists.andrew.name'}</h1>
                <img src='./images/team/andrew.jpg'>
                <p>#{translate 'team.scientists.andrew.description'}</p>
              </div>

              <div class='team-member'>
                <h1>#{translate 'team.scientists.alison.name'}</h1>
                <img src='./images/team/alison.jpg'>
                <p>#{translate 'team.scientists.alison.description'}</p>
              </div>

              <div class='team-member'>
                <h1>#{translate 'team.scientists.jorge.name'}</h1>
                <img src='./images/team/jorge.png'>
                <p>#{translate 'team.scientists.jorge.description'}</p>
              </div>

              <div class='team-member'>
                <h1>#{translate 'team.scientists.tom.name'}</h1>
                <img src='http://placehold.it/150X150'>
                <p>#{translate 'team.scientists.tom.description'}</p>
              </div>
            </div>

            <div class='content sub-nav-team-developers'>
              <h1>Developers</h1>
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

  tasks:
    pickOne:
      type: 'drawing',
      choices: [{
        type: FreeDrawTool,
        label: 'Default'
      }]
