slides = [
  {
    image: "/tutorial-kelp.jpg"
    title: "Welcome to Kelp Hunters"
    content: "This will be a tutorial slide"
  }, 
  {
    image: '/tutorial-kelp-highlight.jpg'
    title: "This is how you mark Kelp"
    content: "This will be a second tutorial slide"
  }, 
  {
    image: "/tutorial-kelp.jpg"
    title: "This is how you do something else"
    content: "This will be the third tutorial slide"
  },
  {
    image: '/tutorial-kelp-highlight.jpg'
    title: "The Last Slide"
    content: "This will be the last tutorial slide"
  }, 
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
