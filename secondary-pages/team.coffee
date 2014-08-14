translate = require 't7e'

module?.exports = "
  <div class='secondary-header'>
    #{translate 'h1', 'team.title'}
  </div>

  <div class='secondary-bg'>
    <div class='secondary-content'>
      <nav class='sub-nav-team'>
        #{translate 'button', 'team.organizations.nav', name: 'organizations'}
        #{translate 'button', 'team.scientists.nav', name: 'scientists'}
        #{translate 'button', 'team.developers.nav', name: 'developers'}
      </nav>
    </div>
    <div class='secondary-content'>
      <div class='left-column'>
        <div class='content sub-nav-team-organizations'>
          <div class='team-member'>
<h1>#{translate 'h1', 'team.organizations.keen.name'}</h1>
            <img src='./images/team/keen.png'>
            #{translate 'p', 'team.organizations.keen.description'}
          </div>

          <div class='team-member'>
            #{translate 'h1', 'team.organizations.santaBarbara.name'}
            <img src='./images/team/sbclter-logo.gif'>
            #{translate 'p', 'team.organizations.santaBarbara.description'}
          </div>

          <div class='team-member'>
            #{translate 'h1', 'team.organizations.nceas.name'}
            <img src='./images/team/nceas.png'>
            #{translate 'p', 'team.organizations.nceas.description'}
          </div>
        </div>

        <div class='content sub-nav-team-scientists'>

          <div class='team-member'>
            #{translate 'h1', 'team.scientists.kyle.name'}
            <img src='./images/team/kyle.jpg'>
            #{translate 'p', 'team.scientists.kyle.description'}
          </div>

          <div class='team-member'>
            #{translate 'h1', 'team.scientists.jarrett.name'}
            <img src='./images/team/jarrett.jpg'>
            #{translate 'p', 'team.scientists.jarrett.description'}
          </div>

          <div class='team-member'>
            #{translate 'h1', 'team.scientists.alejandro.name'}
            <img src='./images/team/alejandro.jpg'>
            #{translate 'p', 'team.scientists.alejandro.description'}
          </div>

          <div class='team-member'>
            #{translate 'h1', 'team.scientists.andrew.name'}
            <img src='./images/team/andrew.jpg'>
            #{translate 'p', 'team.scientists.andrew.description'}
          </div>

          <div class='team-member'>
            #{translate 'h1', 'team.scientists.alison.name'}
            <img src='./images/team/alison.jpg'>
            #{translate 'p', 'team.scientists.alison.description'}
          </div>

          <div class='team-member'>
            #{translate 'h1', 'team.scientists.jorge.name'}
            <img src='./images/team/jorge.jpg'>
            #{translate 'p', 'team.scientists.jorge.description'}
          </div>

          <div class='team-member'>
            #{translate 'h1', 'team.scientists.tom.name'}
            <img src='./images/team/tom.jpg'>
            #{translate 'p', 'team.scientists.tom.description'}
          </div>
        </div>

        <div class='content sub-nav-team-developers'>
          <div class='team-member'>
            #{translate 'h1', 'team.developers.alex.name'}
            <img src='./images/team/alex.jpg'>
            #{translate 'p', 'team.developers.alex.description'}
          </div>

          <div class='team-member'>
            #{translate 'h1', 'team.developers.heath.name'}
            <img src='./images/team/heath.jpg'>
            #{translate 'p', 'team.developers.heath.description'}
          </div>

          <div class='team-member'>
            #{translate 'h1', 'team.developers.julie.name'}
            <img src='./images/team/julie.jpg'>
            #{translate 'p', 'team.developers.julie.description'}
          </div>

          <div class='team-member'>
            #{translate 'h1', 'team.developers.laura.name'}
            <img src='./images/team/laura.jpg'>
            #{translate 'p', 'team.developers.laura.description'}
          </div>


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
