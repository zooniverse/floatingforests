project = require "zooniverse-readymade/current-project"
translate = require "t7e"


MainNav =
  translateReadymadeLinks: (pages...) ->
    # translate existing readymade links matching site.#{page}Link in translations file

    links = $(".readymade-site-links")

    for page in pages
      links.find("a[href$='#/#{page}']")
        .html translate('span', "site.#{page}Link")

  addNavLinks: ->
    project.header.addNavLink "http://talk.floatingforests.org", translate('span', 'site.talkLink')
    project.header.addNavLink "http://blog.floatingforests.org", translate('span', 'site.blogLink')

module?.exports = MainNav
