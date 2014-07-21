translate = require "t7e"
Tutorial = require "../tutorial/tutorial"
UserGoals = require "../user-goals/user-goals"
project = require "zooniverse-readymade/current-project"
User = require "zooniverse/models/user"
ClassifySummary = require "./summary"
ClassifyMetadata = require "./metadata"
ClassifyTransitioner = require "./transitioner"
ClassifySubjectLoader = require "./subject-loader"

classifyPage = project.classifyPages[0]
subjectViewer = classifyPage.subjectViewer
Subject = classifyPage.Subject
tools = subjectViewer.markingSurface.tools

el = $(".readymade-classify-page")

incrementUserClassifyCount = ->
  currentCount = +User?.current?.preferences?.kelp?.classify_count
  User?.current?.setPreference "classify_count", currentCount + 1

Subject.on "no-more", => el.html translate 'div', 'classifyPage.noMoreSubjects', id: 'no-more-subjects'
Subject.on 'get-next', => el.find(".subject-loader").show()
Subject.on 'select', => el.find(".subject-loader").hide()

tutorial = new Tutorial
el.find("#tutorial-tab").on 'click', => tutorial.start()

SPLIT_GROUP = location.search.substring(1).split("=")[1] # this will come from back-end
userGoals = new UserGoals SPLIT_GROUP if SPLIT_GROUP    # ex. url: http://localhost:2005/index.html?split=G#/about

User.on 'change', => tutorial.showIfNewUser()
User.on 'change', => userGoals?.showIfNeeded()
User.fetch()

classifyTransition = new ClassifyTransitioner el

classifyPage.on classifyPage.LOAD_SUBJECT, (e, subject) ->
  classifyPage.classification.annotations.push {clouds: false} # clouds start as false
  ClassifyMetadata.setSubject(subject)

  if ClassifySubjectLoader.firstSubject
    ClassifyMetadata.load()
    ClassifySubjectLoader.handleFirstSubject()

classifyPage.on classifyPage.SEND_CLASSIFICATION, ->
  currentAppState =
    nextSubject: el.find(".right-image")
    oldSubject: el.find(".summary-overlay")
    readymadeSubjectViewer: el.find(".readymade-subject-viewer").hide() # hide center container during transition
    queuedImage: ClassifySubjectLoader.nextImage()
    nextSubjectOverlay: el.find(".right-image-overlay")

  ClassifySummary.addSummary(tools.length, subjectViewer.subject)

  classifyTransition.run(currentAppState)

  incrementUserClassifyCount()

  userGoals?.promptOrUpdateCurrentGoal()