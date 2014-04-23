Footer = require 'zooniverse/controllers/footer'
SubNav = require './sub-nav'
Tutorial = require "./tutorial"
ClassifyMenu = require "./classify-menu"

# add open sans font
$('head').append("<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,700,800' rel='stylesheet' type='text/css'>")

project = require "zooniverse-readymade/current-project"
classifyPage = project.classifyPages[0]
subjectViewer = classifyPage.subjectViewer
tools = subjectViewer.markingSurface.tools
markingsurface = subjectViewer.markingSurface

aboutNav = new SubNav "about"

$ ->
  # additional sections
  footer = new Footer
  $("<div id='footer-container'></div>").insertAfter(".stack-of-pages")
  footer.el.appendTo document.getElementById("footer-container")

  $("""
      <div class='home-content'>
        <div class='readymade-main-stack'>
          <h2>Why is kelp so great?</h2>
          <p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?</p>
        </div>
      </div>
    """).insertAfter(".stack-of-pages")

  $("""
      <div id='location-data'>
        <h2>Location</h2>
        <p>34'00'02.3 N, 120'14'55.0 W</p>
      </div>
    """).insertBefore(".readymade-classification-interface")

  $(".stack-of-pages div:nth-child(4)").addClass("readymade-about-page")
  $(".stack-of-pages div:nth-child(5)").addClass("readymade-discuss-page")

  $(".decision-tree-confirmation").prepend("""
    <div id="custom-buttons">
      <div class="third"><button id='map'>Map</button></div>
      <div class="third"><button id='clouds-present'>C</button><p>Clouds Present?<p></div>
      <div class="third"><button id='undo'>Undo</button></div>
    </div>
  """)

  ClassifyMenu.create()
  menu = new ClassifyMenu

  $(".readymade-call-to-action").html "Get Started"

  $("button[name='decision-tree-confirm-task']").html("Next Subject")

  # events
  $(".readymade-site-link").on "click", (e) ->
    $(@).addClass("active").siblings().removeClass("active")

  $("button#clouds-present").on "click", (e) ->
    $(@).toggleClass("present")
    classifyPage.classification.annotations[0].clouds = $(@).hasClass("present")

  $("button#undo").on "click", (e) -> tools[tools.length-1].destroy() if tools.length

  window.onresize = =>
    $(".summary-overlay").removeClass("mobile-done") if window.innerWidth > 900

  # tutorial / guide
  Tutorial.create()
  tut = new Tutorial

  $("#tutorial").on 'click', => tut.start()

class ClassifyPageEvents
  @firstSubject = true

  classifyPage.on classifyPage.LOAD_SUBJECT, (e, subject) =>
    classifyPage.classification.annotations.push {clouds: false} # clouds start as false
    if @firstSubject
      nextImage = $("<img class='right-image right' src='#{classifyPage.Subject.instances[1].location.standard}'>")
      $(".readymade-subject-viewer-container").append(nextImage)
    @firstSubject = false

  classifyPage.on classifyPage.SEND_CLASSIFICATION, =>
    nextSubject = $(".right-image")
    oldSummary = $(".summary-overlay")
    nextSubjectButton = $("button[name='decision-tree-confirm-task']").prop 'disabled', true

    # show the summary screen
    @addSummary(tools.length, subjectViewer.subject.location.standard)

    # add the next image offscreen
    nextImage = $("<img class='right-image right offscreen-right' src='#{classifyPage.Subject.instances[2].location.standard}'>")
    $(".readymade-subject-viewer-container").append(nextImage)

    setTimeout =>
      # move the old summary offscreen
      oldSummary.addClass("offscreen-left")

      # move the new summary to the old summary location
      newSummary = $(".summary-overlay").removeClass("centered")

      # create floating effect and mobile support
      readymadeSubjectViewer = $(".readymade-subject-viewer").hide()
      newSummary.addClass("mobile-done") if window.innerWidth < 900

      # move the new subject into the center position
      nextSubject.removeClass("right")

      # move the next image from offscreen-right to right panel
      nextImage.removeClass("offscreen-right")

      setTimeout (=>
        # code to execute at end of css transition - this timing should match the css transition
        $("button#clouds-present").removeClass("present")
        nextSubject.remove()
        oldSummary.remove()
        readymadeSubjectViewer.show()
        nextSubjectButton.prop 'disabled', false
      ), 1000
    , 1000 # time that 'Nice Work' screen is displayed

  @addSummary: (kelpNum, image) ->
    $("""
      <div class='summary-overlay centered'>
        <div class='content'>
          <h1>Nice Work!</h1>
          <img class='prev-image' src='#{image}'>
          <p>You Marked</p>
          <p class='bold-data' id='kelp-num'>#{kelpNum} kelp bed#{if kelpNum is 1 then '' else 's'}</p>
          <p>Located near</p>
          <p class='bold-data'>34'00'02.3 N</p>
          <p class='bold-data'>120'14'55.0 W</p>
          <a>Discuss on Talk</a>
        </div>
      </div>
     """).fadeIn(300).appendTo(".readymade-subject-viewer-container")

#TODO: 1. make nice work animation smoother
#      2. add 'next subject' text to upcoming image
