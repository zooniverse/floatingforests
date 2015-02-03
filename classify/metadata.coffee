translate = require 't7e'

ClassifyMetadata =
  roundTo: (dec, num) -> if num then parseFloat(num).toFixed(dec) else "-"

  formattedTimestamp: (ts) ->
    date = new Date(ts)
    "#{date.getMonth()+1}-#{date.getDate()}-#{date.getFullYear()}"

  setSubject: (subject) -> @subject = subject

  googleMapsLink: (lat, long) ->
    "https://www.google.com/maps/@#{lat},#{long},25000m/data=!3m1!1e3"

  load: ->
    [lat, long] = @subject.coords
    timestamp = @subject.metadata.timestamp
    $("#subject-coords")
      .html "<a target='_tab' href='#{@googleMapsLink(long, lat)}'>#{@roundTo(3, long)} N, #{@roundTo(3, lat)}</a>, #{@formattedTimestamp(timestamp)}"
    # TODO: lat / long are reversed here ~ coming in backwards from server

  init: ->
    $(".readymade-classification-interface")
      .prepend "<div id='location-data'>#{translate 'h2', 'site.location'}<p id='subject-coords'></p></div>"

module?.exports = ClassifyMetadata
