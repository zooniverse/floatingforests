translate = require "t7e"
enUs = require './en-us'
translate.load enUs

Footer = require 'zooniverse/controllers/footer'
SubNav = require './sub-nav'
Tutorial = require "./tutorial"
ClassifyMenu = require "./classify-menu"
project = require "zooniverse-readymade/current-project"

classifyPage = project.classifyPages[0]
subjectViewer = classifyPage.subjectViewer
tools = subjectViewer.markingSurface.tools
aboutNav = new SubNav "about"
aboutNav = new SubNav "education"

project.header.el.append("""
  <link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,700,800' rel='stylesheet' type='text/css'>
  <meta name="viewport" content="width=600, user-scalable=no">
""")

$ ->
  # additional sections
  footer = new Footer
  menu = new ClassifyMenu

  $("<div id='footer-container'></div>").insertAfter(".stack-of-pages")
  footer.el.appendTo document.getElementById("footer-container")

  $("""
      <div class='home-content'>
        <div class='readymade-main-stack'>
          <h2>#{translate 'homeSecondary.header'}</h2>
          <p>#{translate 'homeSecondary.p1'}</p>
        </div>
      </div>
    """).insertAfter(".stack-of-pages")

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

  $("button[name='decision-tree-confirm-task']").html translate 'classifyPage.next'

  # events
  $("button#clouds-present").on "click", (e) ->
    $(@).toggleClass("present")
    classifyPage.classification.annotations[0].clouds = $(@).hasClass("present")

  $("button#undo").on "click", (e) -> tools[tools.length-1].destroy() if tools.length

  # tutorial / guide
  tut = new Tutorial

  $("#tutorial-tab").on 'click', => tut.start()

class ClassifyPageEvents
  @firstSubject = true

  @mobile: -> window.innerWidth < 900

  @roundTo: (dec, num) -> if num then parseFloat(num).toFixed(dec) else "-"

  @formattedTimestamp: (ts) -> ts.match(/\d{4}-\d{2}-\d{2}/)[0]

  window.onresize = =>
    $(".summary-overlay").removeClass("mobile-done") if not @mobile()

  classifyPage.on classifyPage.LOAD_SUBJECT, (e, subject) =>
    [@lat, @long] = subject.coords
    @timestamp = subject.metadata.timestamp
    classifyPage.classification.annotations.push {clouds: false} # clouds start as false
    if @firstSubject
      nextImage = @nextImage(1)
      $(".readymade-subject-viewer-container").append(nextImage)
      @loadMetadata()
    @firstSubject = false

  classifyPage.on classifyPage.SEND_CLASSIFICATION, =>
    nextSubject = $(".right-image")
    oldSummary = $(".summary-overlay")
    nextSubjectButton = $("button[name='decision-tree-confirm-task']").prop 'disabled', true
    readymadeSubjectViewer = $(".readymade-subject-viewer").hide() # hide center container during transition

    # show the summary screen
    @addSummary(tools.length, subjectViewer.subject.location.standard)

    # add the next image offscreen
    nextImage = @nextImage()
    rightImageOverlay = $(".right-image-overlay")

    $(".readymade-subject-viewer-container").append(nextImage)

    setTimeout =>
      # move the old summary offscreen
      oldSummary.addClass("offscreen-left")

      # move the new summary to the old summary location
      newSummary = $(".summary-overlay").removeClass("centered")

      # mobile support
      newSummary.addClass("mobile-done") if window.innerWidth < 900

      # move the new subject into the center position
      nextSubject.removeClass("right")

      # fade out the summary
      rightImageOverlay.addClass("invisible")

      # move the next image from offscreen-right to right panel
      nextImage.removeClass("offscreen-right")

      setTimeout (=>
        # code to execute at end of css transition - this timing should match the css transition
        $("button#clouds-present").removeClass("present")
        $("#classify-menu").trigger("new-subject")
        @loadMetadata()
        nextSubject.remove()
        oldSummary.remove()
        readymadeSubjectViewer.show()
        nextSubjectButton.prop 'disabled', false
      ), 1000
    , 500 # time that 'Nice Work' screen is displayed

  @loadMetadata: -> $("#subject-coords").html """
      <a target='_tab' href='https://www.google.com/maps/@#{@lat},#{@long},12z'>#{@roundTo(3, @lat)} N, #{@roundTo(3, @long)} W</a>, #{@formattedTimestamp(@timestamp)}
    """

  @nextImage: (queue = 2) ->
    # queue is 2 by default to load the image 2 ahead of subject into the offscreen-right position
    $("""
      <div class='right-image right #{'offscreen-right' if queue is 2}'>
        <div class='right-image-overlay'></div>
        <img src="#{classifyPage.Subject.instances[queue].location.standard}">
      </div>
    """)

  @addSummary: (kelpNum, image) ->
    $("""
      <div class='summary-overlay centered'>
        <div class='content'>
          <h1>#{translate 'classifyPage.summary.header'}</h1>
          <p>#{translate 'classifyPage.summary.youMarked'}</p>
          <p class='bold-data' id='kelp-num'>#{kelpNum} kelp bed#{if kelpNum is 1 then '' else 's'}</p>
          <p>#{translate 'classifyPage.summary.locatedNear'}</p>
          <p class='bold-data'>#{@roundTo(3, @lat)} N<br>#{@roundTo(3, @long)} W</p>
          <a onclick='alert("Talk features will become available once Kelp is launched")'>#{translate 'classifyPage.summary.talk'}</a>
        </div>
        <img class='prev-image' src='#{image}'>
      </div>
     """).fadeIn(300).appendTo(".readymade-subject-viewer-container")
