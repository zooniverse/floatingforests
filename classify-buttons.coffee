project = require "zooniverse-readymade/current-project"
classifyPage = project.classifyPages[0]
subjectViewer = classifyPage.subjectViewer
tools = subjectViewer.markingSurface.tools

class ClassifyButtons
  constructor: (@el) ->
    @clouds = @el.find("button#clouds-present")
    @undo =  @el.find("button#undo")
    @nextSubject = @el.find("button[name='decision-tree-confirm-task']")

    @clouds.on "click", (e) =>
      @clouds.toggleClass("present")
      classifyPage.classification?.annotations[0].clouds = @clouds.hasClass("present")

    @undo.on "click", (e) => tools[tools.length-1].destroy() if tools.length

  resetClouds: -> @clouds.removeClass("present")

  disableNextSubject: -> @nextSubject.prop 'disabled', true

  enableNextSubject: -> @nextSubject.prop 'disabled', false


module?.exports = ClassifyButtons