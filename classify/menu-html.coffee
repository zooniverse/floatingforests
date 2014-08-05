translate = require 't7e'

module?.exports =
  "<div id='classify-menu'>
    <div class='menu-tabs'>
      <div class='tab' id='tutorial-tab'><img src='./icons/tut.svg'>#{translate 'classifyMenu.tab.tutorial'}</div>
      <div class='tab'><img src='./icons/guide.svg'>#{translate 'classifyMenu.tab.fieldGuide'}</div>
      <div class='tab'><img src='./icons/location.svg'>#{translate 'classifyMenu.tab.location'}</div>
      <div class='tab' id='favorites-tab'><img src='./icons/favorite.svg'>#{translate 'classifyMenu.tab.favorites'}</div>
    </div>

    <div class='menu-content'>
      <div class='menu-section'>
        <!-- Tutorial Menu section -->
      </div>
      <div class='menu-section' id='field-guide'>
        <h1>#{translate 'classifyMenu.content.fieldGuide'}</h1>
        <div class='guide-item kelp'>
          <p>#{translate 'classifyMenu.content.kelp'}</p>
        </div>
        <div class='guide-item kelp-alt'>
          <p>#{translate 'classifyMenu.content.kelp'}</p>
        </div>
        <div class='guide-item clouds'>
          <p>#{translate 'classifyMenu.content.clouds'}</p>
        </div>
      </div>
      <div class='menu-section'>
        <button class='location-btn' id='all-locations'>#{translate 'classifyMenu.locations.all'}</button>
        <button class='location-btn' id='california'>#{translate 'classifyMenu.locations.california'}</button>
        <button class='location-btn' id='tasmania'>#{translate 'classifyMenu.locations.tasmania'}</button>
        <p>#{translate 'em', 'classifyMenu.locations.delayMessage'}</p>
      </div>
      <div class='menu-section'>
        <!--Favorites Menu Section-->
      </div>
    </div>

    <div class='preload'>
      <img src='./images/kelp-before1.jpg'>
      <img src='./images/kelp-before2.jpg'>
    </div>
  </div>"
