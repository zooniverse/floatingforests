translate = require "t7e"
enUs = require './en-us'
translate.load enUs

Footer = require 'zooniverse/controllers/footer'
SecondarySubNav = require './secondary-sub-nav'
ClassifyMenu = require "./classify-menu"
UserGoals = require "./user-goals"
project = require "zooniverse-readymade/current-project"
User = require "zooniverse/models/user"
ClassifyPageEvents = require "./classify-page-events"

classifyPage = project.classifyPages[0]
subjectViewer = classifyPage.subjectViewer
Subject = classifyPage.Subject
tools = subjectViewer.markingSurface.tools

aboutNav = new SecondarySubNav "about"
educationNav = new SecondarySubNav "education"
teamNav = new SecondarySubNav "team"
footer = new Footer
menu = new ClassifyMenu

project.header.el.append("<meta name='viewport' content='width=600, user-scalable=no'>")
footer.el.appendTo $("<div id='footer-container'></div>").insertAfter(".stack-of-pages")

$("""
    <div id='location-data'>
      <h2>#{translate 'site.location'}</h2>
      <p id='subject-coords'></p>
    </div>
  """).insertBefore(".readymade-classification-interface")

$(".decision-tree-confirmation")
  .prepend "<div class='side-btn'><button id='clouds-present'></button></div>"
  .append "<div class='side-btn'><button id='undo'></button></div>"

$(".readymade-call-to-action").html translate 'site.callToAction'

$(".readymade-subject-viewer-container").append "<div class='subject-loader'></div>"

$("button[name='decision-tree-confirm-task']").html translate 'classifyPage.next'

$(".zooniverse-profile")
  .wrapInner "<div class='content'></div>"
  .prepend "<div class='secondary-header'><h1>Your Profile</h1></div>"

# events
$ -> ClassifyPageEvents.setupListeners()
