translate = require 't7e'

module?.exports = "
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
            <img src='./images/team/kyle.jpg'>
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
            <img src='./images/team/jorge.jpg'>
            <p>#{translate 'team.scientists.jorge.description'}</p>
          </div>

          <div class='team-member'>
            <h1>#{translate 'team.scientists.tom.name'}</h1>
            <img src='./images/team/tom.jpg'>
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