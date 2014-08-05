translate = require "t7e"
User = require "zooniverse/models/user"
Masker = require "../masker/masker"

ClassifySummary =
  roundTo: (dec, num) -> if num? then parseFloat(num).toFixed(dec) else ""

  addSummary: (percentCircled, subject) ->
    [lat, long] = subject.coords

    summaryData =
      lat: lat
      long: long
      image: subject.location.standard
      talkLink: subject.talkHref()
      percentCircled: percentCircled

    @summary(summaryData)
      .fadeIn(300).appendTo(".readymade-subject-viewer-container")

  userSetAGoal: ->
    User?.current?.preferences?.kelp?.goal_set is 'true'

  summary: ({percentCircled, image, lat, long, talkLink}) ->
    $ "<div class='summary-overlay centered'>
         <div class='content'>
           <h1>#{translate 'classifyPage.summary.header'}</h1>
           <p>#{translate 'classifyPage.summary.youMarked'}</p>
           <p class='bold-data' id='kelp-num'>#{@roundTo(2, percentCircled)}% of the image</p>
           <p>#{translate 'classifyPage.summary.locatedNear'}</p>
           <p class='bold-data'>#{@roundTo(3, lat)} N<br>#{@roundTo(3, long)} W</p>
          #{if @userSetAGoal() then @goalText() else ''}
           <a href='#{talkLink}'>#{translate 'classifyPage.summary.talk'}</a>
         </div>
         <img class='prev-image' src='#{image}'>
       </div>"

  goalText: ->
    "<p>Goal Countdown:</p>
     <p class='bold-data'>#{User?.current?.preferences?.kelp?.goal}</p>"

module?.exports = ClassifySummary
