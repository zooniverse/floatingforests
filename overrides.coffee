translate = require "t7e"
enUs = require './translations/en-us'
translate.load enUs

LanguageManager = require 'zooniverse/lib/language-manager'
languageManager = new LanguageManager
  translations:
    en: label: 'English', strings: enUs

Footer = require 'zooniverse/controllers/footer'
SecondarySubNav = require './secondary-pages/sub-nav'
ClassifyMenu = require "./classify/menu"
project = require "zooniverse-readymade/current-project"

ProfileOverrides = require "./zooniverse/profile"

ClassifyMetadata = require "./classify/metadata"
ClassifyButtons = require "./classify/buttons"
ClassifySubjectLoader = require "./classify/subject-loader"

AboutNav = new SecondarySubNav "about"
EducationNav = new SecondarySubNav "education"
TeamNav = new SecondarySubNav "team"

footer = new Footer
classifyMenu = new ClassifyMenu

project.header.el.append("<meta name='viewport' content='width=600, user-scalable=no'>")
project.header.el.append("<link rel='shortcut icon' href='favicon.ico' type='image/x-icon'>'")

footer.el.appendTo $("<div id='footer-container'></div>").insertAfter(".stack-of-pages")

ClassifyMetadata.init()
ClassifyButtons.init()
ClassifySubjectLoader.init()
ProfileOverrides.init()

GoogleAnalytics = require 'zooniverse/lib/google-analytics'
analytics = new GoogleAnalytics
  account: 'UA-1224199-59'
  domain: 'floatingforests.org'

addDirectNavLink = (name, url) ->
  $(".readymade-site-links")
    .append "<a href='#{url}' class='readymade-site-link'>#{name}</a>"

addDirectNavLink translate('site.talkLink'), "http://talk.floatingforests.org"
addDirectNavLink translate('site.blogLink'), "http://blog.floatingforests.org/"

$(".readymade-call-to-action").html translate 'site.callToAction'

$ -> require "./classify/events"
