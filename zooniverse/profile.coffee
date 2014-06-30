ProfileOverrides =
  el: $(".zooniverse-profile")
  
  init: ->
    @appendHTML()
    @setInputPlaceholders()

  appendHTML: ->
    @el
      .wrapInner "<div class='content'></div>"
      .prepend "<div class='secondary-header'><h1>Your Profile</h1></div>"  

  setInputPlaceholders: ->
    @el.find(".zooniverse-login-form input[name='username']")
      .attr 'placeholder', 'Username'

    @el.find(".zooniverse-login-form input[name='password']")
      .attr 'placeholder', 'Password'

module?.exports = ProfileOverrides