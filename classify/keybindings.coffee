ClassifyKeybindings =
  keymap:
    c: 67
    n: 78
    del: 8

  classifyPageIsActive: -> location.hash is "#/classify"

  notSigningIn: -> !$(".zooniverse-dialog").hasClass("showing")

  handleKeyPress: (key, buttons) -> 
    switch key
      when @keymap.c then buttons.clouds.click()
      when @keymap.n then buttons.nextSubject.click()
      when @keymap.del then e.preventDefault()

  init: (classifyButtons) ->
    $(document).on 'keydown', (e) =>
      if @classifyPageIsActive() and @notSigningIn()
        @handleKeyPress(e.which, classifyButtons)

module?.exports = ClassifyKeybindings
