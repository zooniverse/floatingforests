project = require "zooniverse-readymade/current-project"
classifyPage = project.classifyPages[0]
subjectViewer = classifyPage.subjectViewer
tools = subjectViewer.markingSurface.tools
translate = require 't7e'

ClassifyButtons =
  init: ->
    @el = classifyPage.el
    @appendDecisionTreeButtons()

    @clouds = @el.find("button#clouds-present")
    @undo = @el.find("button#undo")
    @nextSubject = @el.find("button[name='decision-tree-confirm-task']").html translate('span', 'classifyPage.next')

    @clouds.on "click", (e) =>
      @clouds.toggleClass("present")
      classifyPage.classification?.annotations[0].clouds = @clouds.hasClass("present")

    @undo.on "click", (e) => tools[tools.length-1].destroy() if tools.length

  appendDecisionTreeButtons: ->
    @el.find(".decision-tree-confirmation")
      .prepend "<div class='side-btn'><button id='clouds-present'></button></div>"
      .append "<div class='side-btn'><button id='undo'></button></div>"

  resetClouds: -> @clouds.removeClass("present")

  disableNextSubject: -> @nextSubject.prop 'disabled', true

  enableNextSubject: -> @nextSubject.prop 'disabled', false

module?.exports = ClassifyButtons
