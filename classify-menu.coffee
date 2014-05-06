project = require "zooniverse-readymade/current-project"
classifyPage = project.classifyPages[0]

class ClassifyMenu
  html = """
    <div class='classify-menu'>
      <div class='menu-tabs'>
        <div class='tab' id='tutorial'>View Tutorial</div>
        <div class='tab'>Open Field Guide</div>
        <div class='tab'>Change Location</div>
        <div class='tab' id='favorites'>Add to Favorites</div>
      </div>

      <div class='menu-content'>
        <div class='menu-section'>
          <h1>Tutorial Menu section</h1>
        </div>
        <div class='menu-section' id="field-guide">
          <h1>Field Guide</h1>
          <div class="guide-item kelp">
            <p>Kelp</p>
          </div>
          <div class="guide-item kelp-alt">
            <p>Kelp</p>
          </div>
          <div class="guide-item clouds">
            <p>Clouds</p>
          </div>
        </div>
        <div class='menu-section'>
          <button class='location-btn'>California</button>
          <button class='location-btn' id="all-locations">All Locations</button>
          <button class='location-btn'>Tasmania</button>
        </div>
        <div class='menu-section'>
          <h1>Favorites Menu Section</h1>
        </div>
      </div>

      <div class="preload">
        <img src='./images/kelp-marked1.jpg'>
        <img src='./images/kelp-before2.jpg'>
      </div>
    </div>
  """

  @create: ->
    $(".readymade-classify-page").append(html)

  constructor: ->
    @menus = $(".menu-section").hide()

    @tab = $(".tab")
    @tab.on "click", (e) => @onTabClick(e)

    @locationBtn = $(".location-btn")
    @locationBtn.on 'click', (e) =>
      @onChangeLocation(e)

    $(".location-btn#all-locations").addClass("selected")

    $("#favorites").on 'click', => @updateFavorite()

  updateFavorite: ->
    classifyPage.classification.favorite = !classifyPage.classification.favorite
    if classifyPage.classification.favorite
      $("#favorites").text("Favorited").addClass("favorited")
    else
      $("#favorites").text("Add to Favorites").removeClass("favorited")

  onTabClick: (e) ->
    # disable default behavior for tutorial and favorite tab
    return if e.target.id is 'tutorial' or e.target.id is 'favorites'
    tabNum = $(e.target).index() + 1
    section = $(".menu-section:nth-child(#{tabNum})")
    if section.is(":visible") then @hide section else @display section

  display: (section) ->
    $(".tab:eq(#{section.index()})").addClass("active").siblings().removeClass("active")
    section.show().addClass("active").siblings().hide().removeClass("active")

  hide: (section) ->
    $(".tab:eq(#{section.index()})").removeClass("active")
    section.hide()

  onChangeLocation: (e) ->
    btnClicked = $(e.target)
    $("#location-data h2").text(btnClicked.text())
    btnClicked.addClass("selected").siblings().removeClass("selected")

module?.exports = ClassifyMenu