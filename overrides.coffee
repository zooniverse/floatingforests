Footer = require 'zooniverse/controllers/footer'
# add open sans font
$('head').append("<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,700,800' rel='stylesheet' type='text/css'>")

$ ->

  # additional sections
  footer = new Footer
  $("<div id='footer-container'></div>").insertAfter(".stack-of-pages")
  footer.el.appendTo document.getElementById("footer-container")

  $("""
      <div class='home-content'>
        <div class='readymade-main-stack'>
          <h2>Why is kelp so great?</h2>
          <p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?</p>
        </div>
      </div>
    """).insertAfter(".stack-of-pages")

  $("<h1 id='classify-header'>Mark all the Kelp you see</h1>").insertBefore(".readymade-classification-interface")

  $(".stack-of-pages div:nth-child(4)").addClass("readymade-about-page")
  $(".stack-of-pages div:nth-child(5)").addClass("readymade-discuss-page")

  $(".decision-tree-confirmation").prepend("""
    <div id="custom-buttons">
      <div class="third"><button id='map'>Map</button></div>
      <div class="third"><button id='clouds-present'>C</button><p>Clouds Present?<p></div>
      <div class="third"><button id='undo'>Undo</button></div>
    </div>
  """)

  $(".readymade-call-to-action").html "Get Started"

  $("button[name='decision-tree-confirm-task']").html("Next Subject")

  $(".readymade-site-link").on "click", (e) ->
    $(@).addClass("active").siblings().removeClass("active")

  $("button#clouds-present").on "click", (e) ->
    $(@).toggleClass("present")

  $(".readymade-subject-viewer-container").append("<img class='left-image' src='http://placehold.it/520X390'>")
  $(".readymade-subject-viewer-container").append("<img class='right-image' src='http://placehold.it/520X390'>")

  $("button[name='decision-tree-confirm-task']").on "click", ->
     $(".marking-surface .frames").children().clone().addClass("left-image").appendTo(".readymade-subject-viewer-container")
