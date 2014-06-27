translate = require "t7e"
User = require "zooniverse/models/user"

ClassifySummary =
  roundTo: (dec, num) -> if num then parseFloat(num).toFixed(dec) else "-"

  addSummary: (kelpNum, subject) ->
    [lat, long] = subject.coords
    image = subject.location.standard

    @summary(kelpNum, image, lat, long)
      .fadeIn(300).appendTo(".readymade-subject-viewer-container")

  summary: (kelpNum, image, lat, long) ->
    $("""
      <div class='summary-overlay centered'>
        <div class='content'>
          <h1>#{translate 'classifyPage.summary.header'}</h1>
          <p>#{translate 'classifyPage.summary.youMarked'}</p>
          <p class='bold-data' id='kelp-num'>#{kelpNum} kelp bed#{if kelpNum is 1 then '' else 's'}</p>
          <p>#{translate 'classifyPage.summary.locatedNear'}</p>
          <p class='bold-data'>#{@roundTo(3, lat)} N<br>#{@roundTo(3, long)} W</p>
          #{if User?.current?.preferences?.kelp?.goal_set is 'true' then @goalText() else ''}
          <a onclick='alert("Talk features will become available once Kelp is launched")'>#{translate 'classifyPage.summary.talk'}</a>
        </div>
        <img class='prev-image' src='#{image}'>
      </div>
     """)

  goalText: -> """
      <p>Goal Countdown:</p>
      <p class='bold-data'>#{User?.current?.preferences?.kelp?.goal}</p>
    """

module?.exports = ClassifySummary