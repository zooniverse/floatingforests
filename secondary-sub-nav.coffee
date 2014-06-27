###
Secondary Page SubNav Usage : readymade

1. Create a nav with class="sub-nav-PAGE_NAME"
    ex: "science", "education"

2. Add buttons to the nav with name="SECTION_NAME"
    ex: "planets", "more-info", etc.

3. Add content sections with class="sub-nav-PAGE_NAME-SECTION_NAME"

4. Name the Readymade page PAGE_NAME
###

class SecondarySubNav
  constructor: (@page) ->
    @el = $(".readymade-generic-page[data-readymade-page='#{@page}']")
    setTimeout => @activateFirstTab(page)

    @el.find(".sub-nav-#{page} button").on "click", (e) =>
      @activateSection(e.target.name)

  showSection: (section) ->
    @el.find(".sub-nav-#{@page}-#{section}")
      .show()
      .siblings().hide()

  activateSubNavLink: (section) ->
    @el.find(".sub-nav-#{@page} button[name=#{section}]")
      .addClass("active")
      .siblings().removeClass("active")

  activateFirstTab: ->
     firstSection = $(".sub-nav-#{@page} button:nth-child(1)").attr('name')
     @activateSection(firstSection)

  activateSection: (section) ->
    @showSection(section)
    @activateSubNavLink(section)

module?.exports = SecondarySubNav
