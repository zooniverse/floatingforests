{Tool} = require "marking-surface"

class FreeDrawTool extends Tool
  stroke: "rgba(255, 255, 255, 1)"
  strokeWidth: 1
  fill: "rgba(255, 255, 255, 0.3)"

  constructor: ->
    super
    @mark.relPath = []
    @path = @addShape 'path', stroke: @stroke, fill: "transparent", strokeWidth: 1
    @path.addEvent "start", @startMove
    @path.addEvent "move", @moveMark

  onInitialStart: (e) ->
    super
    {x, y} = @coords e
    @mark.startingPoint = [x, y]
    @mark.relPath.push [0,0]

  onInitialMove: (e) ->
    super
    {x, y} = @coords e
    @mark.relPath.push [@xDiff(x), @yDiff(y)]
    @mark.set {startingPoint: @mark.startingPoint, relPath: @mark.relPath}
    @render()

  onInitialRelease: (e) ->
    super
    @path.attr {fill: @fill}
    @render()
    @destroy() if @mark.relPath.length is 1 #don't record single clicks

  xDiff: (x) -> x - @xPathCoord()

  yDiff: (y) -> y - @yPathCoord()

  startMove: (e) =>
    {x, y} = @coords e
    @xOffset = x - @mark.startingPoint[0]
    @yOffset = y - @mark.startingPoint[1]

  moveMark: (e) =>
    {x, y} = @coords e
    @mark.startingPoint = [x - @xOffset, y - @yOffset]
    @mark.set {startingPoint: @mark.startingPoint}

  render: ->
    super
    if @mark.relPath.length > 1
      @path.attr {d: @pathDescription()}
      @controls?.moveTo {x: @maxX(), y: @maxY()}

  pathDescription: ->
    "m #{@mark.startingPoint}, #{@mark.relPath.join(',')} #{if @isComplete() then ' Z' else ''}"

  xPathCoord: (index = @mark.relPath.length-1) ->
    # x coord at index or last point in relPath
    @mark.startingPoint[0] + (p[0] for p in @mark.relPath[0..index]).reduce (acc, x) -> acc + x

  yPathCoord: (index = @mark.relPath.length-1) ->
    # y coord at index or last point in relPath
    @mark.startingPoint[1] + (p[1] for p in @mark.relPath[0..index]).reduce (acc, y) -> acc + y

  maxX: -> Math.max (p[0] for p in @_coordsOfPath())...

  maxY: -> Math.max (p[1] for p in @_coordsOfPath())...

  _coordsOfPath: ->
    ([@xPathCoord(i), @yPathCoord(i)] for point, i in @mark.relPath)

module?.exports = FreeDrawTool
