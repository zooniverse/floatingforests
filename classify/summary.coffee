translate = require "t7e"
project = require "zooniverse-readymade/current-project"
{ User } = project.classifyPages[0]

ClassifySummary =
  roundTo: (dec, num) -> if num? then parseFloat(num).toFixed(dec) else ""

  display: (areaCircled, subject) ->
    [lat, long] = subject.coords

    summaryData =
      lat: lat
      long: long
      image: subject.location.standard
      talkLink: subject.talkHref()
      areaCircled: areaCircled

    @summary(summaryData)
      .fadeIn(300).appendTo(".readymade-subject-viewer-container")

  userSetAGoal: ->
    User?.current?.preferences?.kelp?.goal_set is 'true'

  summary: ({areaCircled, image, lat, long, talkLink}) ->
    $ "<div class='summary-overlay centered'>
         <div class='content'>
           <div class='summary-content-top'>
             <h1>#{translate 'classifyPage.summary.header'}</h1>
             <p>#{translate 'classifyPage.summary.youMarked'}</p>
             <p class='bold-data' id='kelp-num'>#{@roundTo(2, areaCircled)} km&sup2 of the image</p>
             <p>#{translate 'classifyPage.summary.locatedNear'}</p>
             <p class='bold-data'>#{@roundTo(3, long)} N<br>#{@roundTo(3, lat)} W</p>
            #{if @userSetAGoal() then @goalText() else ''}
           </div>
           <a href='#{talkLink}'>#{translate 'classifyPage.summary.talk'}</a>
         </div>
         <img class='prev-image' src='#{image}'>
       </div>"
    # TODO: switch lat/long positions when back-end data is corrected

  goalText: ->
    "<p>Goal Countdown:</p>
     <p class='bold-data'>#{User?.current?.preferences?.kelp?.goal}</p>"

module?.exports = ClassifySummary
