User = require "zooniverse/models/user"

class UserGoals
  html = """
    <div id='user-goals'>
      <h1>User Goals</h1>
      <button name='user-goal-close'><img id='tut-x-icon' src='./icons/x-icon.svg'></button>
      <div id='content'></div>
      <button name='user-goal-submit'>Set Goal</button>
    </div>
  """

  SLIDER = """
    <p id='slider-val'>0 Classifications</p>
    <form id='user-goal-form'>
      <input id='user-goal-slider' type='range' value='0' max='50' step='1'>
    </form>
  """

  RADIOS = """
    <form id='user-goal-form'>
      <input type="radio" name="goal-radio" value="10">10
      <input type="radio" name="goal-radio" value="20">20
      <input type="radio" name="goal-radio" value="30">30
      <input type="radio" name="goal-radio" value="40">40
      <input type="radio" name="goal-radio" value="50">50
    </form>
  """

  Messages =
    personallyMotivated: "You contributed 20 classifications your last session. Would you like to set a higher goal for this session?"
    sociallyMotivated: "Kelp Hunters citizen scientists have contributed 20 classifications per session. Would you like to set a goal?"

  constructor: (@splitGroup) -> # @splitGroup = 'A', 'B ,'C' or 'D'
    @create()
    @el = $("#user-goals")
    @content = @el.find("#content")
    console.log "hello from user goals"
    console.log User?.current?.preferences

    @populateContent()

    @el.find("button[name='user-goal-submit']").on 'click', => @setUserGoal()
    @el.find("button[name='user-goal-close']").on 'click', => @el.remove()

    # User.current.setPreference ""

  create: -> $(".readymade-classify-page").append html

  populateContent: ->
    switch @splitGroup
      when 'A'
        @content.append Messages.personallyMotivated, RADIOS
      when 'B'
        @content.append Messages.sociallyMotivated, RADIOS
      when 'C'
        @content.append Messages.personallyMotivated, SLIDER
        @listenForSliderChange()
      when 'D'
        @content.append Messages.sociallyMotivated, SLIDER
        @listenForSliderChange()

  listenForSliderChange: ->
    goalSlider = @el.find("#user-goal-slider")
    goalSlider.val(0)
    goalSlider.on 'input', (e) =>
      @goal = goalSlider.val()
      @el.find("#slider-val").text(@goal + " Classifications")

  setUserGoal: ->
    @goal or= @el.find("#user-goal-form input[type='radio']:checked").val()
    console.log "user Goal SET!", @goal

    @el.html("<h1>Goal set for #{@goal} Classifications</h1>")

    User?.current?.setPreference "goal", @goal
    time = new Date()
    User?.current?.deletePreference "goal_set_date"

    setTimeout =>
      time.setDate(time.getDate() + 1)
      User?.current?.setPreference "goal_end_date", time
      @el.remove()
    , 2000


module?.exports = UserGoals