project = require "zooniverse-readymade/current-project"
classifyPage = project.classifyPages[0]
translate = require "t7e"

class ClassifyMenu
  GROUPS =
    'all-locations': true
    'california': "53ac8475edf877f0bc000002"
    'tasmania': "536d226d3ae740fd20000003"

  html = require "./menu-html"

  FAVORITE_TEXT  = "<img src='./icons/favorite.svg'>#{translate 'classifyMenu.tab.favorites'}"

  FAVORITED_TEXT = "#{translate 'classifyMenu.tab.favorited'}"

  create: -> $(".readymade-classify-page").append(html)

  constructor: ->
    @create()
    @el = $("#classify-menu")

    @tab = @el.find(".tab")
    @locationBtns = @el.find(".location-btn")
    @favoritesTab = @el.find("#favorites-tab")
    @scrollUp = @el.find('.scroll-up')
    @fieldGuideTab = @el.find("#field-guide-tab")

    @tab.on "click", (e) => @onTabClick(e)
    @locationBtns.on 'click', (e) => @onChangeLocation(e)
    @favoritesTab.on 'click', => @updateFavorite()
    @el.on "new-subject", => @resetFavoriteTab()
    @scrollUp.on 'click', => @scrollToTopNav()

    @activate @locationBtns.filter("#all-locations")

  onTabClick: (e) ->
    tab = e.target
    return if @notOpenable(tab)
    @displayTabSection(tab)
    if @openingFieldGuide(tab) then @scrollToFieldGuide() else @scrollToBottomOfSiteFooter()

  onChangeLocation: (e) ->
    location = e.target.id
    @selectGroup location
    btnClicked = @el.find("#" + location)
    @activate btnClicked
    $("#location-data h2").text(btnClicked.text())

  updateFavorite: ->
    @toggleFavorite()
    if @favorited() then @activateFavoriteTab() else @resetFavoriteTab()

  resetFavoriteTab: ->
    @deactivateFavoriteTab() if @favoritesTab.hasClass("favorited")

  favorited: -> classifyPage.classification.favorite

  toggleFavorite: ->
    classifyPage.classification.favorite = !classifyPage.classification.favorite

  selectGroup: (locationKey) ->
    classifyPage.Subject.group = GROUPS[locationKey]

  activateFavoriteTab: ->
    @favoritesTab.text(FAVORITED_TEXT).addClass("favorited")

  deactivateFavoriteTab: ->
    @favoritesTab.html(FAVORITE_TEXT).removeClass("favorited")

  notOpenable: (tab) -> tab.id in ['tutorial-tab', 'favorites-tab']

  openingFieldGuide: (tab) ->
    tab.id is 'field-guide-tab' and @fieldGuideTab.hasClass('active')

  tabNum: (tab) -> @el.find(tab).index() + 1

  displayTabSection: (tab) ->
    section = @correspondingSectionTo(tab)
    if section.is(":visible") then @hide section else @display section

  correspondingSectionTo: (tab) ->
    @el.find(".menu-section:nth-child(#{@tabNum(tab)})")

  correspondingTabTo: (section) ->
    @el.find(".tab:eq(#{section.index()})")

  scrollToFieldGuide: ->
    $("html, body").animate({ scrollTop:(@fieldGuideTab.offset().top - 100)}, 500)

  scrollToBottomOfSiteFooter: ->
    $("html, body").animate({ scrollTop:($("#footer-container").offset().top - window.innerHeight)}, 500)

  scrollToTopNav: ->
    $("html, body").animate({scrollTop:($(".readymade-classification-interface").offset().top)}, 600)

  activate: (el) ->
    el.addClass("active").siblings().removeClass("active")

  show: (el) ->
    el.show().siblings().hide()

  display: (section) ->
    @activate @correspondingTabTo(section)
    @show section

  hide: (section) ->
    section.hide()
    @correspondingTabTo(section).removeClass("active")

module?.exports = ClassifyMenu

