ClassifyButtons = require "./buttons"

ClassifyKeybindings =
  keymap:
    c: 67
    n: 78
    del: 8

  classifyPageIsActive: -> location.hash is "#/classify"

  notSigningIn: -> !$(".zooniverse-dialog").hasClass("showing")

  handleKeyPress: (e) ->
    key = e.which
    switch key
      when @keymap.c then @buttons.clouds.click()
      when @keymap.n then @buttons.nextSubject.click()
      when @keymap.del then e.preventDefault()

  init: ->
    @buttons = ClassifyButtons

    $(document).on 'keydown', (e) =>
      if @classifyPageIsActive() and @notSigningIn()
        @handleKeyPress(e)

module?.exports = ClassifyKeybindings
