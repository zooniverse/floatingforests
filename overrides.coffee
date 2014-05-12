Footer = require 'zooniverse/controllers/footer'
SubNav = require './sub-nav'
Tutorial = require "./tutorial"
ClassifyMenu = require "./classify-menu"

# add open sans font
$('head').append("""
  <link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,700,800' rel='stylesheet' type='text/css'>
  <meta name="viewport" content="width=540, user-scalable=no">
""")

$(".readymade-site-links").append("<a class='readymade-site-link' href='https://docs.google.com/a/zooniverse.org/forms/d/1gfpaTZ-kS3UefF5CpRlfEQwv4s9rIBPY18PZyBZcCfw/viewform'>Feedback</a>")

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
        <p id='subject-coords'></p>
      </div>
    """).insertBefore(".readymade-classification-interface")

  $(".decision-tree-confirmation").prepend("""
    <div id="custom-buttons">
      <div class="third"><button id='map'>Map</button></div>
      <div class="third"><button id='clouds-present'></button><p>Clouds Present?<p></div>
      <div class="third"><button id='undo'>Undo</button></div>
    </div>
  """)

  ClassifyMenu.create()
  menu = new ClassifyMenu

  $(".readymade-call-to-action").html "Get Started"

  $("button[name='decision-tree-confirm-task']").html("Next Subject")

  # events
  $("button#clouds-present").on "click", (e) ->
    $(@).toggleClass("present")
    classifyPage.classification.annotations[0].clouds = $(@).hasClass("present")

  $("button#undo").on "click", (e) -> tools[tools.length-1].destroy() if tools.length

  # tutorial / guide
  Tutorial.create()
  tut = new Tutorial

  $("#tutorial").on 'click', => tut.start()

class ClassifyPageEvents
  @firstSubject = true

  @mobile: -> window.innerWidth < 900

  window.onresize = =>
    $(".summary-overlay").removeClass("mobile-done") if not @mobile()

  classifyPage.on classifyPage.LOAD_SUBJECT, (e, subject) =>
    [@lat, @long] = subject.coords
    classifyPage.classification.annotations.push {clouds: false} # clouds start as false
    if @firstSubject
      nextImage = @nextImage(1)
      $(".readymade-subject-viewer-container").append(nextImage)
      @loadLatLong()
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
        $("#favorites").text("Add to Favorites").removeClass("favorited") # reset fav
        @loadLatLong()
        nextSubject.remove()
        oldSummary.remove()
        readymadeSubjectViewer.show()
        nextSubjectButton.prop 'disabled', false
      ), 1000
    , 1000 # time that 'Nice Work' screen is displayed

  @loadLatLong: -> $("#subject-coords").html("<a target='_tab' href='https://www.google.com/maps/@#{@lat},#{@long},8z'>#{@lat}, #{@long}</a>")

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
          <h1>Nice Work!</h1>
          <p>You Marked</p>
          <p class='bold-data' id='kelp-num'>#{kelpNum} kelp bed#{if kelpNum is 1 then '' else 's'}</p>
          <p>Located near</p>
          <p class='bold-data'>34'00'02.3 N</p>
          <p class='bold-data'>120'14'55.0 W</p>
          <a onclick='alert("Talk features will become available once Kelp is launched")'>Discuss on Talk</a>
        </div>
        <img class='prev-image' src='#{image}'>
      </div>
     """).fadeIn(300).appendTo(".readymade-subject-viewer-container")

#TODO: 1. make the transition code less grimey
#      2. subject size- make full
