class ClassifyMenu
  html = """
    <div class='classify-menu'>
      <div class='menu-tabs'>
        <div class='tab' id='tutorial'>View Tutorial</div>
        <div class='tab'>Open Field Guide</div>
        <div class='tab'>Change Location</div>
        <div class='tab'>Add to Favorites</div>
      </div>

      <div class='menu-content'>
        <div class='menu-section'>
          <h1>Tutorial Menu section</h1>
        </div>
        <div class='menu-section'>
          <h1>Field Guide Menu Section</h1>
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

  onTabClick: (e) ->
    return if e.target.id is 'tutorial' # disable default behavior for tutorial tab
    tabNum = $(e.target).index() + 1
    section = $(".menu-section:nth-child(#{tabNum})")
    if section.is(":visible") then @hide section else @display section

  display: (section) ->
    $(".tab:nth-child(#{section.index() + 1}").addClass("active").siblings().removeClass("active")
    section.show().addClass("active").siblings().hide().removeClass("active")

  hide: (section) ->
    $(".tab:nth-child(#{section.index() + 1}").removeClass("active")
    section.hide()

  onChangeLocation: (e) ->
    btnClicked = $(e.target)
    $("#location-data h2").text(btnClicked.text())
    btnClicked.addClass("selected").siblings().removeClass("selected")


module?.exports = ClassifyMenu