translate = require "t7e"

slides = [
  {
    image: "./images/tutorial-kelp-1.jpg"
    title: translate "tutorial.step1.header"
    content: translate "tutorial.step1.content"
  }, 
  {
    image: './gifs/kelp-tut.gif'
    title: translate "tutorial.step2.header"
    content: translate "tutorial.step2.content"
  }, 
  {
    image: "./gifs/kelp-tut-delete.gif"
    title: translate "tutorial.step3.header"
    content: translate "tutorial.step3.content"
  },
  {
    image: './images/clouds-1.jpg'
    title: translate "tutorial.step4.header"
    content: translate "tutorial.step4.content"
  },
  {
    image: './images/tutorial-kelp.jpg'
    title: translate "tutorial.step5.header"
    content: translate "tutorial.step5.content"
  }
]

class Tutorial
  html = """
    <div class='tutorial' id='tutorial-bg'>
      <div class='tutorial-slide'>
        <button id='close'><span id='skip'>#{translate 'tutorial.skip'}</span><img id='tut-x-icon' src='./icons/x-icon.svg'></button>

        <div id='slides-container'></div>

        <button id='next'>#{translate 'tutorial.next'}</button>
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

    @nextBtn.html(if num is @numberOfSlides then translate 'tutorial.finish' else translate 'tutorial.next')

  onClickNext: ->
    if @currentSlide() is @numberOfSlides
      @exit()
    else
      @showSlide(@currentSlide() + 1) 

  exit: ->
    @tutorial.fadeOut(250)
    window.removeEventListener "click", @exitIfClickOutside

module?.exports = Tutorial
