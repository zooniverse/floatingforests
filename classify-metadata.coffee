ClassifyMetadata =
  roundTo: (dec, num) -> if num then parseFloat(num).toFixed(dec) else "-"

  formattedTimestamp: (ts) -> ts.match(/\d{4}-\d{2}-\d{2}/)[0]

  setSubject: (subject) -> @subject = subject

  load: ->
    [lat, long] = @subject.coords
    timestamp = @subject.metadata.timestamp
    $("#subject-coords").html """
      <a target='_tab' href='https://www.google.com/maps/@#{lat},#{long},12z'>#{@roundTo(3, lat)} N, #{@roundTo(3, long)} W</a>, #{@formattedTimestamp(timestamp)}
    """

module?.exports = ClassifyMetadata