ClassifyButtons = require "./buttons"
ClassifyMetadata = require "./metadata"

class ClassifyTransitioner
  SUMMARY_TIME = 500
  MOBILE_SUMMARY_TIME = 2000
  TRANSITION_TIME = 1000 # match to css transition

  constructor: ->
    @el = $(".readymade-classify-page")
    @buttons = ClassifyButtons

  mobile: -> window.innerWidth < 1070

  summaryDisplayTime: ->
    if @mobile() then MOBILE_SUMMARY_TIME else SUMMARY_TIME

  run: (state) ->
    @appendQueuedImage(state)
    @buttons.disableNextSubject()
    setTimeout (=> @executeTransition(state)), @summaryDisplayTime()

  executeTransition: (state) ->
    @moveAllImagesLeft(state)
    @fadeOutOverlay(state)
    @resetAfterTransition(state)

  moveAllImagesLeft: ({oldSubject, nextSubject, queuedImage}) ->
    @moveLeftSubjectOffscreen(oldSubject)
    @moveSummaryLeft()
    @moveRightSubjectToCenter(nextSubject)
    @displayQueuedImage(queuedImage)

  fadeOutOverlay: ({nextSubjectOverlay}) ->
    nextSubjectOverlay.addClass("invisible")

  resetAfterTransition: (state) ->
    setTimeout (=> @resetClassifyPage(state)), TRANSITION_TIME

  resetClassifyPage: (state) ->
    @resetClassifyMenu(state)
    ClassifyMetadata.load()

  resetClassifyMenu: ({nextSubject, oldSubject}) ->
    @buttons.resetClouds()
    @el.find("#classify-menu").trigger("new-subject")
    @removeElements(nextSubject, oldSubject)
    @el.find(".readymade-subject-viewer").show()
    @buttons.enableNextSubject()

  appendQueuedImage: ({queuedImage}) ->
    @el.find(".readymade-subject-viewer-container").append(queuedImage)

  removeElements: (elements...) ->
    el.remove() for el in elements

  moveLeftSubjectOffscreen: (oldSubject) ->
    oldSubject.addClass("offscreen-left")

  moveSummaryLeft: ->
    @el.find(".summary-overlay").removeClass("centered")

  moveRightSubjectToCenter: (nextSubject) ->
    nextSubject.removeClass("right")

  displayQueuedImage: (nextImage) ->
    nextImage.removeClass("offscreen-right")

module?.exports = ClassifyTransitioner
