translate = require "t7e"
Tutorial = require "../tutorial/tutorial"
Masker = require '../masker/masker'
UserGoals = require "../user-goals/user-goals"
userSplit = require "../user-goals/user-split"
project = require "zooniverse-readymade/current-project"

Summary = require "./summary"
Metadata = require "./metadata"
SubjectLoader = require "./subject-loader"
Keybindings = require "./keybindings"
Buttons = require "./buttons"

ClassifyTransitioner = require "./transitioner"
ClassifyMenu = require "./menu"

Metadata.init()
Buttons.init()
Keybindings.init()
SubjectLoader.init()

menu = new ClassifyMenu
transition = new ClassifyTransitioner
tutorial = new Tutorial

classifyPage = project.classifyPages[0]
{subjectViewer, Subject, el,
 LOAD_SUBJECT, SEND_CLASSIFICATION, USER_CHANGE} = classifyPage
tools = subjectViewer.markingSurface.tools

SUBJECT_WIDTH = 532 #px
SUBJECT_HEIGHT = 484 #px
SUBJECT_AREA = 16.603 #sq km

userGoals = null
setUserGoals = =>
  userGoals = new UserGoals userSplit() if userSplit()

Subject.on "no-more", => el.html translate 'div', 'classifyPage.noMoreSubjects', id: 'no-more-subjects'
Subject.on 'get-next', => el.find(".subject-loader").show()
Subject.on 'select', => el.find(".subject-loader").hide()
el.find("#tutorial-tab").on 'click', => tutorial.start()

classifyPage.on USER_CHANGE, (e, user) ->
  setUserGoals()
  tutorial.showIfNewUser()
  userGoals?.showIfNeeded()

classifyPage.on LOAD_SUBJECT, (e, subject) ->
  classifyPage.classification.annotations.push {clouds: false} # clouds start as false
  Metadata.setSubject(subject)

  if SubjectLoader.firstSubject
    Metadata.load()
    SubjectLoader.handleFirstSubject()

classifyPage.on SEND_CLASSIFICATION, (e, classifier) ->
  paths = classifier.classification.annotations[1].value
  masker = new Masker { paths, width: SUBJECT_WIDTH, height: SUBJECT_HEIGHT }
  areaCircled = masker.portionArea(SUBJECT_AREA)

  currentAppState =
    nextSubject: el.find(".right-image")
    oldSubject: el.find(".summary-overlay")
    readymadeSubjectViewer: el.find(".readymade-subject-viewer").hide() # hide center container during transition
    queuedImage: SubjectLoader.nextImage()
    nextSubjectOverlay: el.find(".right-image-overlay")

  Summary.display(areaCircled, subjectViewer.subject)

  transition.run(currentAppState)

  userGoals?.promptOrUpdateCurrentGoal()

