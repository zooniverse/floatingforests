ClassifyButtons = require "./buttons"
ClassifyMetadata = require "./metadata"

class ClassifyTransitioner
  SUMMARY_DISPLAY_TIME = 500
  TRANSITION_TIME = 1000 # match to css transition

  constructor: (@el) ->
    @buttons = new ClassifyButtons @el

  run: (state) ->
    @appendQueuedImage(state)
    setTimeout (=> @executeTransition(state)), SUMMARY_DISPLAY_TIME

  executeTransition: (state) ->
    @buttons.disableNextSubject()
    @moveAllImagesLeft(state)
    @fadeOutOverlay(state)
    @resetAfterTransition(state)

  moveAllImagesLeft: ({oldSubject, nextSubject, queuedImage}) ->
    @moveLeftSubjectOffscreen(oldSubject)
    @moveSummaryLeft()
    @moveRightSubjectToCenter(nextSubject)
    @displayQueuedImage(queuedImage)  # move this to other method that just handles the queued image

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