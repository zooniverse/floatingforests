project = require "zooniverse-readymade/current-project"
{ User } = project.classifyPages[0]

class UserGoals
  html =
   "<div id='user-goals'>
      <button name='user-goal-close'><img id='tut-x-icon' src='./icons/x-icon.svg'></button>
      <div id='content'></div>
    </div>"

  HEADER = "<h1>User Goals</h1>"

  SUBMIT_BUTTON = "<button name='user-goal-submit'>Set Goal</button>"

  SESSION_TIME = 30 #minutes

  # To generate IMAGE_FILES (from root in irb):
  # Dir.entries("public/images/old_kelp_maps").map {|e| e.gsub!(/\D/, "").to_i }.reject {|n| n == 0}
  IMAGE_FILES = [26, 27, 29, 30, 31, 32, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 49, 50, 51, 52, 61]

  @sampleArray: (arr) -> arr[Math.floor(Math.random() * arr.length)]

  @randomKelpImage: -> @sampleArray(IMAGE_FILES)

  Input =
    min: 1
    max: 50
    slider:
     "<p id='slider-val'></p>
      <form id='user-goal-form'>
        <input type='range' id='user-goal-slider' min='1' max='50' step='1'>
      </form>"

  Feedback =
    message: "<h1 class='user-goal-feedback-message'>Classification Goal Achieved!<br>Thank you for your efforts!</h1>"
    image: "<h1>Classification Goal Achieved!<br>Thank you for your efforts!<br>Enjoy this kelp map from 1912</h1><img src='./images/old_kelp_maps/#{@randomKelpImage()}.jpeg'>"

  Messages =
    personallyMotivated: "You can set goals in Floating Forests to manage your contribution. Would you like to set a goal for this session?"
    personallyMotivatedAlt: (num) -> "Last session you contributed #{num} classifications. Would you like to set a classification goal for your session?"
    sociallyMotivated: "Kelp Hunters citizen scientists have contributed 20 classifications per session. Would you like to set a goal?"

  SPLIT =
    a:
      message: Messages.personallyMotivated
      input: Input.min
      feedback: Feedback.image
    b:
      message: Messages.personallyMotivated
      input: Input.min
      feedback: Feedback.message
    c:
      message: Messages.personallyMotivated
      input: Input.max
      feedback: Feedback.image
    d:
      message: Messages.personallyMotivated
      input: Input.max
      feedback: Feedback.message
    e:
      message: Messages.sociallyMotivated
      input: Input.min
      feedback: Feedback.image
    f:
      message: Messages.sociallyMotivated
      input: Input.min
      feedback: Feedback.message
    g:
      message: Messages.sociallyMotivated
      input: Input.max
      feedback: Feedback.image
    h:
      message: Messages.sociallyMotivated
      input: Input.max
      feedback: Feedback.message

  constructor: (@splitGroup) ->
    @create(html)
    @el = $("#user-goals")
    @content = @el.find("#content")
    @closed = false

    @el.find("button[name='user-goal-close']").on 'click', @onClickClose

  create: -> $(".readymade-classify-page").append html

  prompt: ->
    @populatePromptContent()
    @el.show()

  userShouldSeeImage: ->
    !!~SPLIT[@splitGroup].feedback.indexOf("img")

  onClickClose: =>
    @el.remove()
    @closed = true

  feedback: ->
    @content.html(SPLIT[@splitGroup].feedback)
    @el.show()
    @el.addClass("feedback-image") if @userShouldSeeImage()
    User?.current?.setPreference "goal_set", "false"

  currentGoal: ->
    +User?.current?.preferences?.kelp?.goal

  goalSet: ->
    User?.current?.preferences?.kelp?.goal_set is 'true'

  userClassifyCount: ->
    +User?.current?.preferences?.kelp?.classify_count

  lastSessionCount: ->
    +User?.current?.preferences?.kelp?.last_session_count

  setLastSessionCount: (count) ->
    User?.current?.setPreference "last_session_count", count

  incrementLastSessionCount: ->
    @setLastSessionCount(@lastSessionCount() + 1)

  promptShouldBeDisplayed: ->
    return if @closed
    (@sessionHasExpired() and @userClassifyCount() > 2) or (@userClassifyCount() is 2)

  showIfNeeded: ->
    @prompt() if @promptShouldBeDisplayed()

  promptOrUpdateCurrentGoal: ->
    if @promptShouldBeDisplayed() then @prompt() else @updateStatus()

  sessionHasExpired: ->
    @dateCountDown() < 0

  completedSuccessfully: ->
    @currentGoal() is 0 and @dateCountDown() > 0 and @goalSet()

  dateCountDown: ->
    endDate = User?.current?.preferences?.kelp?.goal_end_date || -1
    dateCountDown = (+Date.parse(endDate) - Date.now())

  decrimentGoal: ->
    User?.current?.setPreference("goal", (@currentGoal() - 1))

  updateStatus: ->
    if @completedSuccessfully() then @feedback() else @decrimentGoal()
    @increaseSessionExpiration()
    @incrementUserClassifyCount()
    @incrementLastSessionCount() unless @sessionHasExpired()

  splitMessage: ->
    lastSessionCount = @lastSessionCount()
    if lastSessionCount > 0
      Messages.personallyMotivatedAlt(lastSessionCount)
    else
      SPLIT[@splitGroup].message

  inputFormHTML: ->
    HEADER + @splitMessage() + Input.slider + SUBMIT_BUTTON

  createInputForm: ->
    @content.html @inputFormHTML()

  populatePromptContent: ->
    @createInputForm()
    @listenForSliderChange()
    @listenForSubmit()

  listenForSubmit: ->
    @el.find("button[name='user-goal-submit']").on 'click', @setUserGoal

  sCheck: (int) ->
    if +int is 1 then '' else 's'

  listenForSliderChange: ->
    goalSlider = @el.find("#user-goal-slider")

    defaultValue = SPLIT[@splitGroup].input
    goalSlider.val(defaultValue)
    @el.find("#slider-val").text(defaultValue + " Classification#{@sCheck(defaultValue)}")
    @goal = defaultValue

    goalSlider.on 'input', (e) =>
      @goal = goalSlider.val()
      @el.find("#slider-val").text(@goal + " Classification#{@sCheck(@goal)}")

  recordGoalHistory: ->
    history = User.current?.preferences?.kelp?.goal_history || {}
    history["#{new Date()}"] = @goal
    User?.current?.setPreference "goal_history", history

  setUserGoal: =>
    @content.html("<h1 class='user-goal-set'>Goal set for #{@goal} Classification#{@sCheck(@goal)}</h1>")

    User?.current?.setPreference "goal_set", "true"
    User?.current?.setPreference "goal", @goal
    @recordGoalHistory()

    @setLastSessionCount(0)

    setTimeout =>
      @increaseSessionExpiration()
      @el.fadeOut()
    , 2000

  increaseSessionExpiration: ->
    time = new Date()
    time.setMinutes(time.getMinutes() + SESSION_TIME)
    User?.current?.setPreference "goal_end_date", time

  incrementUserClassifyCount: ->
    currentCount = +User.current?.preferences?.kelp?.classify_count
    User?.current?.setPreference "classify_count", currentCount + 1

module?.exports = UserGoals
