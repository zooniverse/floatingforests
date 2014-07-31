project = require "zooniverse-readymade/current-project"
ClassifyMetadata = require "./metadata"
classifyPage = project.classifyPages[0]

ClassifySubjectLoader =
  firstSubject: true

  handleFirstSubject: ->
    if @firstSubject
      $(".readymade-subject-viewer-container").append(@nextImage(1))
      @firstSubject = false
      ClassifyMetadata.load()

  nextImageSrc: (queueNum) ->
    classifyPage.Subject.instances[queueNum]?.location.standard

  nextImage: (queue = 2) ->
    # queue is 2 by default to load the image 2 ahead of subject into the offscreen-right position
    $ "<div class='right-image right #{'offscreen-right' if queue is 2}'>
         <div class='right-image-overlay'></div>
         <img src='#{@nextImageSrc(queue)}'>
       </div>"

  init: ->
    $(".readymade-subject-viewer-container")
      .append "<div class='subject-loader'></div>"

module?.exports = ClassifySubjectLoader
