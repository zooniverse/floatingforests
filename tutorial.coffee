slides = [
  {
    image: "./tutorial-kelp.jpg"
    title: "Welcome to Kelp Hunters"
    content: "This is a brief tutorial to guide you through the steps to classify on Kelp Hunters"
  }, 
  {
    image: './tutorial-kelp-highlight.jpg'
    title: "Basics of Marking"
    content: "To mark an area of Kelp, simply click and drag your mouse on the image. When you release, the remaining line will be filled in to make a complete shape."
  }, 
  {
    image: "./tutorial-kelp.jpg"
    title: "Removing Bad Marks"
    content: "You can remove a bad or accidental mark by clicking the mark, then pressing “Delete”. You may also click “Undo” below to remove the last mark you did."
  },
  {
    image: './tutorial-kelp-highlight.jpg'
    title: "Identifying Clouds"
    content: "You may occasionally spot clouds obscuring the view of the coastline. When you see this, click the “Clouds Present” button below. Do mark any kelp you can see!"
  },
  {
    image: './tutorial-kelp-highlight.jpg'
    title: "Happy Hunting"
    content: "Thank you for your interest in Kelp Hunters! We are very grateful for your time. You can discuss the project with other volunteers by visiting Talk"
  }
]

class Tutorial
  html = """
    <div class='tutorial'>
      <div class='tutorial-slide'>
        <button id='close'><span id='skip'>SKIP</span> X</button>

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

    @closeBtn.on 'click', => @tutorial.fadeOut(250)
    @nextBtn.on 'click', => @onClickNext()
    @dot.on 'click', (e) => @showSlide $(e.target).index() + 1

    @numberOfSlides = $(".dot").size()

  start: ->
    @tutorial.fadeIn(250)
    @showSlide(1)

  currentSlide: -> $('.dot.active').index() + 1

  showSlide: (num) ->
    $("#slide#{num}").show().siblings().hide()
    $(".dot:nth-child(#{num})").addClass("active").siblings().removeClass("active")

    @nextBtn.html(if num is @numberOfSlides then "Finish" else "Next")

  onClickNext: ->
    if @currentSlide() is @numberOfSlides
      @tutorial.fadeOut(250)
    else
      @showSlide(@currentSlide() + 1) 

module?.exports = Tutorial