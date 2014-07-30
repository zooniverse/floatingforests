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
    sociallyMotivated: "Kelp Hunters citizen scientists have contributed 20 classifications per session. Would you like to set a goal?"

  SPLIT =
    A:
      message: Messages.personallyMotivated
      input: Input.min
      feedback: Feedback.image
    B:
      message: Messages.personallyMotivated
      input: Input.min
      feedback: Feedback.message
    C:
      message: Messages.personallyMotivated
      input: Input.max
      feedback: Feedback.image
    D:
      message: Messages.personallyMotivated
      input: Input.max
      feedback: Feedback.message
    E:
      message: Messages.sociallyMotivated
      input: Input.min
      feedback: Feedback.image
    F:
      message: Messages.sociallyMotivated
      input: Input.min
      feedback: Feedback.message
    G:
      message: Messages.sociallyMotivated
      input: Input.max
      feedback: Feedback.image
    H:
      message: Messages.sociallyMotivated
      input: Input.max
      feedback: Feedback.message

  constructor: (@splitGroup) ->
    @create(html)
    @el = $("#user-goals")
    @content = @el.find("#content")
    @closed = false

    @el.find("button[name='user-goal-submit']").on 'click', => @setUserGoal()

    # TODO: remove feedback class on close / or 'opt-out' on close / or just keep as is?
    @el.find("button[name='user-goal-close']").on 'click', =>
      @el.remove()
      @closed = true

  create: -> $(".readymade-classify-page").append html

  prompt: ->
    @populatePromptContent()
    @el.show()

  userShouldSeeImage: ->
    !!~SPLIT[@splitGroup].feedback.indexOf("img")

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

  inputFormHTML: ->
    HEADER + SPLIT[@splitGroup].message + Input.slider + SUBMIT_BUTTON

  createInputForm: ->
    @content.html @inputFormHTML()

  populatePromptContent: ->
    @createInputForm()
    @listenForSliderChange()
    @listenForSubmit()

  listenForSubmit: ->
    @el.find("button[name='user-goal-submit']").on 'click', => @setUserGoal()

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

  setUserGoal: ->
    @content.html("<h1 class='user-goal-set'>Goal set for #{@goal} Classification#{@sCheck(@goal)}</h1>")

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
