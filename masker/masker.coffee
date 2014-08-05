project = require "zooniverse-readymade/current-project"
classifyPage = project.classifyPages[0]

class Masker
  id: 'masker'
  context: null
  paths: null
  width: 100
  height: 100

  constructor: (params) ->
    @[key] = value for key, value of params when key of @

    canvas = document.createElement 'canvas'
    canvas.width = @width
    canvas.height = @height
    canvas.id = @id

    @context = canvas.getContext '2d'
    @context.fillStyle = '#000000'
    @context.fillRect 0, 0, @width, @height

    @mask()

  mask: ->
    return unless @paths
    for { relPath, startingPoint } in @paths
      [startX, startY] = startingPoint
      @context.beginPath()
      @context.moveTo startX, startY
      @currentPosition = [startX, startY]

      for relChange in relPath
        [x, y] = (@currentPosition[i] += value for value, i in relChange)
        @context.lineTo x, y

      @context.closePath()
      @context.fillStyle = '#ffffff'
      @context.fill()

  portion: ->
    totalPixels = @width * @height
    maskedPixels = 0

    maskData = @context.getImageData(0, 0, @width, @height).data
    for pos in [0..maskData.length] by 4
      continue unless maskData[pos] is 255
      continue unless maskData[pos + 1] is 255
      continue unless maskData[pos + 2] is 255
      maskedPixels += 1

    maskedPixels / totalPixels

  percent: -> @portion() * 100

module.exports = Masker
