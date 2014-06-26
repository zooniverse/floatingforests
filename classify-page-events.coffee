translate = require "t7e"
Tutorial = require "./tutorial"
UserGoals = require "./user-goals"
project = require "zooniverse-readymade/current-project"
User = require "zooniverse/models/user"

classifyPage = project.classifyPages[0]
subjectViewer = classifyPage.subjectViewer
Subject = classifyPage.Subject
tools = subjectViewer.markingSurface.tools

class ClassifyPageEvents
  @el = $(".readymade-classify-page")

  @firstSubject = true

  @roundTo: (dec, num) -> if num then parseFloat(num).toFixed(dec) else "-"

  @formattedTimestamp: (ts) -> ts.match(/\d{4}-\d{2}-\d{2}/)[0]

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
    nextSubject = @el.find(".right-image")
    oldSummary = @el.find(".summary-overlay")
    nextSubjectButton = @el.find("button[name='decision-tree-confirm-task']").prop 'disabled', true
    readymadeSubjectViewer = @el.find(".readymade-subject-viewer").hide() # hide center container during transition

    @addSummary(tools.length, subjectViewer.subject.location.standard)

    nextImage = @nextImage()
    rightImageOverlay = @el.find(".right-image-overlay")

    @el.find(".readymade-subject-viewer-container").append(nextImage)

    setTimeout =>
      # move the old summary offscreen
      oldSummary.addClass("offscreen-left")

      # move the new summary to the old summary location
      newSummary = $(".summary-overlay").removeClass("centered")

      # move the new subject into the center position
      nextSubject.removeClass("right")

      # fade out the summary
      rightImageOverlay.addClass("invisible")

      # move the next image from offscreen-right to right panel
      nextImage.removeClass("offscreen-right")

      setTimeout (=>
        # code to execute at end of css transition - this timing should match the css transition
        @el.find("button#clouds-present").removeClass("present")
        @el.find("#classify-menu").trigger("new-subject")
        @loadMetadata()
        nextSubject.remove()
        oldSummary.remove()
        readymadeSubjectViewer.show()
        nextSubjectButton.prop 'disabled', false
      ), 1000
    , 500 # time that 'Nice Work' screen is displayed

    @incrementUserClassifyCount()
    if @userGoals?.promptShouldBeDisplayed() then @userGoals.prompt() else @userGoals?.updateStatus()

  @incrementUserClassifyCount: ->
    currentCount = +User?.current?.preferences?.kelp?.classify_count
    User?.current?.setPreference "classify_count", (currentCount + 1)

  @loadMetadata: -> @el.find("#subject-coords").html """
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
    goalText = """
      <p>Goal Countdown:</p>
      <p class='bold-data'>#{User?.current?.preferences?.kelp?.goal}</p>
    """
    $("""
      <div class='summary-overlay centered'>
        <div class='content'>
          <h1>#{translate 'classifyPage.summary.header'}</h1>
          <p>#{translate 'classifyPage.summary.youMarked'}</p>
          <p class='bold-data' id='kelp-num'>#{kelpNum} kelp bed#{if kelpNum is 1 then '' else 's'}</p>
          <p>#{translate 'classifyPage.summary.locatedNear'}</p>
          <p class='bold-data'>#{@roundTo(3, @lat)} N<br>#{@roundTo(3, @long)} W</p>
          #{if User?.current?.preferences?.kelp?.goal_set is 'true' then goalText else ''}
          <a onclick='alert("Talk features will become available once Kelp is launched")'>#{translate 'classifyPage.summary.talk'}</a>
        </div>
        <img class='prev-image' src='#{image}'>
      </div>
     """).fadeIn(300).appendTo(".readymade-subject-viewer-container")

  @showTutorialIfNew: =>
    classifyCount = User?.current?.preferences?.kelp?.classify_count
    unless classifyCount
      @tutorial.start()
      User?.current?.setPreference "classify_count", 0

  @showUserGoalsIfNeeded: =>
    @userGoals.prompt() if @userGoals?.promptShouldBeDisplayed()

  @setupListeners: ->
    Subject.on "no-more", =>
      @el.html translate 'div', 'classifyPage.noMoreSubjects', id: 'no-more-subjects'

    Subject.on 'get-next', => @el.find(".subject-loader").show()
    Subject.on 'select', => @el.find(".subject-loader").hide()

    @tutorial = new Tutorial
    @el.find("#tutorial-tab").on 'click', => @tutorial.start()

    SPLIT_GROUP = location.search.substring(1).split("=")[1] # this will come from back-end
    @userGoals = new UserGoals SPLIT_GROUP if SPLIT_GROUP    # ex. url: http://localhost:2005/index.html?split=G#/about

    User.on('change', @showTutorialIfNew) # (e, user) =>
    User.on('change', @showUserGoalsIfNeeded)
    User.fetch()

    @el.find("button#clouds-present").on "click", (e) ->
      cloudButton = $(@).toggleClass("present")
      classifyPage.classification.annotations[0].clouds = cloudButton.hasClass("present")

    @el.find("button#undo").on "click", (e) -> tools[tools.length-1].destroy() if tools.length

module?.exports = ClassifyPageEvents