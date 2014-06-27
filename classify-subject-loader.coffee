project = require "zooniverse-readymade/current-project"
ClassifyMetadata = require "./classify-metadata"
classifyPage = project.classifyPages[0]

ClassifySubjectLoader =
  firstSubject: true

  handleFirstSubject: ->
    if @firstSubject
      $(".readymade-subject-viewer-container").append(@nextImage(1))
      @firstSubject = false
      ClassifyMetadata.load()

  nextImage: (queue = 2) ->
    # queue is 2 by default to load the image 2 ahead of subject into the offscreen-right position
    $("""
      <div class='right-image right #{'offscreen-right' if queue is 2}'>
        <div class='right-image-overlay'></div>
        <img src="#{classifyPage.Subject.instances[queue].location.standard}">
      </div>
    """)

module?.exports = ClassifySubjectLoader