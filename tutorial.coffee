slides = [
  {
    image: "./images/tutorial-kelp-highlight.jpg"
    title: "Welcome to Kelp Hunters"
    content: "This is a brief tutorial to guide you through the steps to classify on Kelp Hunters"
  }, 
  {
    image: './gifs/kelp-tut.gif'
    title: "Basics of Marking"
    content: "To mark an area of kelp, simply click and drag your mouse on the image. When you release, any remaining gap will be filled in to make a complete polygon."
  }, 
  {
    image: "./gifs/kelp-tut-delete.gif"
    title: "Removing Bad Marks"
    content: "You can remove a bad or accidental mark by clicking the mark, then pressing your delete key. You may also click “Undo” below to remove the last mark you did."
  },
  {
    image: './images/clouds-1.jpg'
    title: "Identifying Clouds"
    content: "You may occasionally spot clouds obscuring the view of the coastline. When you see this, click the “Clouds Present” button below. Do mark any kelp you can see!"
  },
  {
    image: './images/tutorial-kelp.jpg'
    title: "Happy Hunting"
    content: "Thank you for your interest in Kelp Hunters! You can discuss the project with the science team and other volunteers by visiting Talk."
  }
]

class Tutorial
  html = """
    <div class='tutorial' id='tutorial-bg'>
      <div class='tutorial-slide'>
        <button id='close'><span id='skip'>SKIP</span><img id='tut-x-icon' src='./icons/x-icon.svg'></button>

        <div id='slides-container'></div>

        <button id='next'>Next</button>
        <div class='dots'></div>
      </div>
    </div>
  """

  @create: ->
    $(".readymade-classify-page").append(html)
    $(".tutorial").hide()
    @dots = $(".dots")

    for slide, i in slides
      $("#slides-container").append("""
        <div id='slide#{i + 1}'>
          <div class='top-half'>
            <img src=#{slide.image}>
          </div>

          <div class='bottom-half'>
            <h1>#{slide.title}</h1>
            <p>#{slide.content}</p>
          </div>
        </div>
      """)
      @dots.append("<div class='dot'></div>")

  constructor: ->
    @tutorial = $(".tutorial")
    @nextBtn = $("button#next")
    @closeBtn = $("button#close")
    @dot = $(".dot")

    @closeBtn.on 'click', => @exit()
    @nextBtn.on 'click', => @onClickNext()
    @dot.on 'click', (e) => @showSlide $(e.target).index() + 1

    @numberOfSlides = slides.length

  start: ->
    @tutorial.fadeIn(250)
    @showSlide(1)
    window.addEventListener "click", @exitIfClickOutside

  exitIfClickOutside: (e) => @exit() if e.target.id is "tutorial-bg"

  currentSlide: -> $('.dot.active').index() + 1

  showSlide: (num) ->
    $("#slide#{num}").show().siblings().hide()
    $(".dot:nth-child(#{num})").addClass("active").siblings().removeClass("active")

    @nextBtn.html(if num is @numberOfSlides then "Finish" else "Next")

  onClickNext: ->
    if @currentSlide() is @numberOfSlides
      @exit()
      # make this in exit, that removes event listeners, and with close button click
    else
      @showSlide(@currentSlide() + 1) 

  exit: ->
    @tutorial.fadeOut(250)
    window.removeEventListener "click", @exitIfClickOutside

module?.exports = Tutorial
