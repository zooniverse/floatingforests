User = require "zooniverse/models/user"

class UserGoals
  html = """
    <div id='user-goals'>
      <button name='user-goal-close'><img id='tut-x-icon' src='./icons/x-icon.svg'></button>
      <div id='content'></div>
    </div>
  """

  HEADER = "<h1>User Goals</h1>"

  SUBMIT_BUTTON = "<button name='user-goal-submit'>Set Goal</button>"

  SESSION_TIME = 1 # TODO: change to 30 min for production

  Input =
    slider: """
      <p id='slider-val'>0 Classifications</p>
      <form id='user-goal-form'>
        <input type='range' id='user-goal-slider' value='25' min='1' max='50' step='1'>
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
    image: "<h1 class='user-goal-feedback'>Alternate feedback!</h1>"

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
    @closed = false

    @el.find("button[name='user-goal-submit']").on 'click', => @setUserGoal()
    @el.find("button[name='user-goal-close']").on 'click', =>
      @el.remove()
      @closed = true

  create: -> $(".readymade-classify-page").append html

  prompt: ->
    @populatePromptContent()
    @el.show()

  feedback: ->
    @content.html(SPLIT[@splitGroup].feedback)
    @el.show().delay(2000).fadeOut()
    User?.current?.setPreference "goal_set", "false"

  currentGoal: ->
    +User?.current?.preferences?.kelp?.goal

  goalSet: ->
    User?.current?.preferences?.kelp?.goal_set is 'true'

  promptShouldBeDisplayed: ->
    @sessionHasExpired() or +User?.current?.preferences?.kelp?.classify_count is 2 and not @closed

  sessionHasExpired: ->
    @dateCountDown() < 0

  completedSuccessfully: ->
    goal = +User?.current?.preferences?.kelp?.goal
    goal is 0 and @dateCountDown() > 0 and @goalSet()

  dateCountDown: ->
    endDate = User?.current?.preferences?.kelp?.goal_end_date
    dateCountDown = (+Date.parse(endDate) - Date.now())

  decrimentGoal: ->
    goal = User?.current?.preferences?.kelp?.goal
    User?.current?.setPreference("goal", (+goal - 1))

  updateStatus: ->
    if @completedSuccessfully() then @feedback() else @decrimentGoal()
    @increaseSessionExpiration()

  populatePromptContent: ->
    @content.html HEADER + SPLIT[@splitGroup].message + SPLIT[@splitGroup].input + SUBMIT_BUTTON
    @listenForSliderChange() if !!~SPLIT[@splitGroup].input.indexOf("user-goal-slider")
    @listenForSubmit()

  listenForSubmit: ->
    @el.find("button[name='user-goal-submit']").on 'click', => @setUserGoal()

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

    @content.html("<h1 class='user-goal-feedback'>Goal set for #{@goal} Classification#{if +@goal is 1 then '' else 's'}</h1>")

    User?.current?.setPreference "goal_set", "true"
    User?.current?.setPreference "goal", @goal

    setTimeout =>
      @increaseSessionExpiration()
      @el.fadeOut()
    , 2000

  increaseSessionExpiration: ->
    time = new Date()
    time.setMinutes(time.getMinutes() + SESSION_TIME)
    User?.current?.setPreference "goal_end_date", time

module?.exports = UserGoals