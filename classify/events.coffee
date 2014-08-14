translate = require "t7e"
Tutorial = require "../tutorial/tutorial"
UserGoals = require "../user-goals/user-goals"
userSplit = require "../user-goals/user-split"
project = require "zooniverse-readymade/current-project"

ClassifySummary = require "./summary"
ClassifyMetadata = require "./metadata"
ClassifyTransitioner = require "./transitioner"
ClassifySubjectLoader = require "./subject-loader"
Masker = require '../masker/masker'
classifyPage = project.classifyPages[0]
subjectViewer = classifyPage.subjectViewer
Subject = classifyPage.Subject
tools = subjectViewer.markingSurface.tools

SUBJECT_WIDTH = 532 #px
SUBJECT_HEIGHT = 484 #px
SUBJECT_AREA = 16.603 #sq km

el = $(".readymade-classify-page")

userGoals = null
setUserGoals = =>
  userGoals = new UserGoals userSplit() if userSplit()

Subject.on "no-more", => el.html translate 'div', 'classifyPage.noMoreSubjects', id: 'no-more-subjects'
Subject.on 'get-next', => el.find(".subject-loader").show()
Subject.on 'select', => el.find(".subject-loader").hide()

tutorial = new Tutorial
el.find("#tutorial-tab").on 'click', => tutorial.start()

classifyTransition = new ClassifyTransitioner el

classifyPage.on classifyPage.USER_CHANGE, (e, user) ->
  setUserGoals()
  tutorial.showIfNewUser()
  userGoals?.showIfNeeded()

classifyPage.on classifyPage.LOAD_SUBJECT, (e, subject) ->
  classifyPage.classification.annotations.push {clouds: false} # clouds start as false
  ClassifyMetadata.setSubject(subject)

  if ClassifySubjectLoader.firstSubject
    ClassifyMetadata.load()
    ClassifySubjectLoader.handleFirstSubject()

classifyPage.on classifyPage.SEND_CLASSIFICATION, (e, classifier) ->
  paths = classifier.classification.annotations[1].value
  masker = new Masker { paths, width: SUBJECT_WIDTH, height: SUBJECT_HEIGHT }
  areaCircled = masker.portionArea(SUBJECT_AREA)

  currentAppState =
    nextSubject: el.find(".right-image")
    oldSubject: el.find(".summary-overlay")
    readymadeSubjectViewer: el.find(".readymade-subject-viewer").hide() # hide center container during transition
    queuedImage: ClassifySubjectLoader.nextImage()
    nextSubjectOverlay: el.find(".right-image-overlay")

  ClassifySummary.addSummary(areaCircled, subjectViewer.subject)

  classifyTransition.run(currentAppState)

  userGoals?.promptOrUpdateCurrentGoal()

