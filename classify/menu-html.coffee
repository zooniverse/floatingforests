translate = require 't7e'

module?.exports =
  "<div id='classify-menu'>
    <div class='menu-tabs'>
      <div class='tab' id='tutorial-tab'>
        <img src='./icons/tut.svg'>
        #{translate 'span', 'classifyMenu.tab.tutorial'}
      </div>
      <div class='tab' id='field-guide-tab'>
        <img src='./icons/guide.svg'>
        #{translate 'span', 'classifyMenu.tab.fieldGuide'}
      </div>
      <div class='tab' id='location-tab'>
        <img src='./icons/location.svg'>
        #{translate 'span', 'classifyMenu.tab.location'}
      </div>
      <div class='tab' id='favorites-tab'>
        <img src='./icons/favorite.svg'>
        #{translate 'span', 'classifyMenu.tab.favorites'}
      </div>
    </div>

    <div class='menu-content'>
      <div class='menu-section'>
        <!-- Tutorial Menu section -->
      </div>
      <div class='menu-section' id='field-guide'>
        #{ translate 'h1', 'classifyMenu.content.fieldGuide' }
        <div class='guide-item kelp'>
          #{translate 'p', 'classifyMenu.content.kelp'}
        </div>
        <div class='guide-item kelp-alt'>
          #{translate 'p', 'classifyMenu.content.kelp'}
        </div>
        <div class='guide-item clouds'>
          #{translate 'p', 'classifyMenu.content.clouds'}
        </div>
          #{translate 'p', 'classifyMenu.content.summary'}
        <div class='guide-item waves'>
          #{translate 'p', 'classifyMenu.content.waves'}
        </div>

        <div class='guide-item land'>
          #{translate 'p', 'classifyMenu.content.land'}
        </div>

        <div class='guide-item faulty'>
          #{translate 'p', 'classifyMenu.content.faulty'}
        </div>
          #{translate 'p', 'classifyMenu.content.badImages'}
        <div class='scroll-up'><img src='./icons/return-top.svg'/></div>
      </div>
      <div class='menu-section'>
        <button class='location-btn' id='all-locations'>
          #{translate 'span', 'classifyMenu.locations.all'}
        </button>
        <button class='location-btn' id='california'>
          #{translate 'span', 'classifyMenu.locations.california'}
        </button>
        <button class='location-btn' id='tasmania'>
          #{translate 'span', 'classifyMenu.locations.tasmania'}
        </button>
        <p>#{translate 'em', 'classifyMenu.locations.delayMessage'}</p>
      </div>
      <div class='menu-section'>
        <!--Favorites Menu Section-->
      </div>
    </div>

    <div class='preload'>
      <img src='./images/kelp-before1.jpg'>
      <img src='./images/kelp-before2.jpg'>
      <img src='./images/faulty-alt.png'>
      <img src='./images/land-alt.jpg'>
      <img src='./images/clouds-alt.png'>
      <img src='./images/beaches.jpg'>
    </div>
  </div>"
