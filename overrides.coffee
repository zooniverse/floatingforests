translate = require "t7e"
enUs = require './translations/en-us'
translate.load enUs

LanguageManager = require 'zooniverse/lib/language-manager'
languageManager = new LanguageManager
  translations:
    en: label: 'English', strings: enUs
    es: label: 'Español', strings: './translations/es.json'
    pl: label: 'Polski', strings: './translations/pl.json'
    'zh-tw': label: '繁體中文', strings: './translations/zh-tw.json'

languageManager.on 'change-language', (e, code, strings) ->
  translate.load strings
  translate.refresh()

Footer = require 'zooniverse/controllers/footer'
MainNav = require './pages/main-nav'
SecondarySubNav = require './pages/sub-nav'
HomeStats = require './pages/home-stats'
project = require "zooniverse-readymade/current-project"

ProfileOverrides = require "./zooniverse/profile"

AboutNav = new SecondarySubNav "about"
EducationNav = new SecondarySubNav "education"
TeamNav = new SecondarySubNav "team"

MainNav.addNavLinks()
MainNav.translateReadymadeLinks('classify', 'profile', 'about', 'education', 'team')

footer = new Footer

project.header.el.append("<meta name='viewport' content='width=600, user-scalable=no'>
                          <link rel='shortcut icon' href='favicon.ico' type='image/x-icon'>")

footer.el.appendTo $("<div id='footer-container'></div>").insertAfter(".stack-of-pages")

creditElement = document.createElement 'div'
creditElement.className = 'image-credit'
creditElement.innerHTML = translate 'span', 'site.backgroundImageCredit'
$('#footer-container').append creditElement

ProfileOverrides.init()

GoogleAnalytics = require 'zooniverse/lib/google-analytics'
analytics = new GoogleAnalytics
  account: 'UA-1224199-59'
  domain: 'floatingforests.org'

$(".readymade-call-to-action").html translate 'site.callToAction'

ClassifyEvents = require "./classify/events"

HomeStats.init()
