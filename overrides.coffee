translate = require "t7e"
enUs = require './translations/en-us'
translate.load enUs

LanguageManager = require 'zooniverse/lib/language-manager'
languageManager = new LanguageManager
  translations:
    en: label: 'English', strings: enUs

Footer = require 'zooniverse/controllers/footer'
SecondarySubNav = require './secondary-pages/sub-nav'
project = require "zooniverse-readymade/current-project"

ProfileOverrides = require "./zooniverse/profile"

AboutNav = new SecondarySubNav "about"
EducationNav = new SecondarySubNav "education"
TeamNav = new SecondarySubNav "team"

footer = new Footer

project.header.el.append("<meta name='viewport' content='width=600, user-scalable=no'>
                          <link rel='shortcut icon' href='favicon.ico' type='image/x-icon'>")

project.header.addNavLink "http://talk.floatingforests.org", translate('site.talkLink')
project.header.addNavLink "http://blog.floatingforests.org", translate('site.blogLink')

footer.el.appendTo $("<div id='footer-container'></div>").insertAfter(".stack-of-pages")

ProfileOverrides.init()

GoogleAnalytics = require 'zooniverse/lib/google-analytics'
analytics = new GoogleAnalytics
  account: 'UA-1224199-59'
  domain: 'floatingforests.org'

$(".readymade-call-to-action").html translate 'site.callToAction'

ClassifyEvents = require "./classify/events"
