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

  SESSION_TIME = 30

  Input =
    slider: """
      <p id='slider-val'>0 Classifications</p>
      <form id='user-goal-form'>
        <input type='range' id='user-goal-slider' value='25' max='50' step='1'>
      </form>
    """
    radios: """
      <form id='user-goal-form'>
        <input type="radio" name="goal-radio" value="10">10
        <input type="radio" name="goal-radio" value="20">20
        <input type="radio" name="goal-radio" value="30">30
        <input type="radio" name="goal-radio" value="40">40
        <input type="radio" name="goal-radio" value="50">50
      </form>
    """

  Feedback =
    message: "<h1 class='user-goal-feedback'>Classification Goal Achieved!</h1>"
    image: "<h1 class='user-goal-feedback'>Alternate feedback! Put a cool kelp image here</h1>"

  Messages =
    personallyMotivated: "You contributed 20 classifications your last session. Would you like to set a higher goal for this session?"
    sociallyMotivated: "Kelp Hunters citizen scientists have contributed 20 classifications per session. Would you like to set a goal?"

  SPLIT =
    A:
      message: Messages.personallyMotivated
      input: Input.radios
      feedback: Feedback.image
    B:
      message: Messages.personallyMotivated
      input: Input.radios
      feedback: Feedback.message
    C:
      message: Messages.personallyMotivated
      input: Input.slider
      feedback: Feedback.image
    D:
      message: Messages.personallyMotivated
      input: Input.slider
      feedback: Feedback.message
    E:
      message: Messages.sociallyMotivated
      input: Input.radios
      feedback: Feedback.image
    F:
      message: Messages.sociallyMotivated
      input: Input.radios
      feedback: Feedback.message
    G:
      message: Messages.sociallyMotivated
      input: Input.slider
      feedback: Feedback.image
    H:
      message: Messages.sociallyMotivated
      input: Input.slider
      feedback: Feedback.message

  constructor: (@splitGroup) ->
    @create(html)
    @el = $("#user-goals")
    @content = @el.find("#content")

    @populateContent()

    @el.find("button[name='user-goal-submit']").on 'click', => @setUserGoal()
    @el.find("button[name='user-goal-close']").on 'click', => @el.remove()

  create: -> $(".readymade-classify-page").append html

  feedback: ->
    @el.show().html(SPLIT[@splitGroup].feedback).delay(2000).fadeOut()

  populateContent: ->
    @content.append SPLIT[@splitGroup].message, SPLIT[@splitGroup].input
    @listenForSliderChange() if SPLIT[@splitGroup].message.indexOf("user-goal-slider")

  listenForSliderChange: ->
    goalSlider = @el.find("#user-goal-slider")

    defaultValue = '25'
    goalSlider.val(defaultValue)
    @el.find("#slider-val").text(defaultValue + " Classifications")
    @goal = defaultValue

    goalSlider.on 'input', (e) =>
      @goal = goalSlider.val()
      @el.find("#slider-val").text(@goal + " Classifications")

  setUserGoal: ->
    @goal or= @el.find("#user-goal-form input[type='radio']:checked").val()

    @el.html("<h1 class='user-goal-feedback'>Goal set for #{@goal} Classifications</h1>")

    User?.current?.setPreference "goal_set", "true"
    User?.current?.setPreference "goal", @goal

    setTimeout =>
      @setGoalEnd()
      @el.fadeOut()
    , 2000

  setGoalEnd: ->
    time = new Date()
    time.setMinutes(time.getMinutes() + SESSION_TIME)
    User?.current?.setPreference "goal_end_date", time

module?.exports = UserGoals