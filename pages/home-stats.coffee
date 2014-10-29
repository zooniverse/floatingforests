translate = require 't7e'

HomePageStats =
  commaNum: (num) ->
    num.toString().replace /(\d)(?=(\d{3})+(?!\d))/g, '$1,'

  createStatsContainer: ->
    $(".readymade-project-description").append "
      <div id='stats-box'>
        <span class='classification-count'>...</span> #{translate 'span', 'home.classifications', class: 'stats-label'}
        <span class='complete-count'>...</span> #{translate 'span', 'home.complete', class: 'stats-label'}
        <span class='user-count'>...</span> #{translate 'span', 'home.users', class: 'stats-label'}
      </div>
     "

  getStats: ->
    $.get 'https://api.zooniverse.org/projects/kelp', (project) =>
      {classification_count, complete_count, user_count} = project
      statsBox = $("#stats-box")
      statsBox.find('.classification-count').html @commaNum classification_count
      statsBox.find('.complete-count').html @commaNum complete_count
      statsBox.find('.user-count').html @commaNum user_count

  init: ->
    @createStatsContainer()
    @getStats()

module?.exports = HomePageStats
