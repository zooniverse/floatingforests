Footer = require 'zooniverse/controllers/footer'
# add open sans font
$('head').append("<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,700' rel='stylesheet' type='text/css'>")

$ ->
  footer = new Footer
  $("<div id='footer-container'></div>").insertAfter(".stack-of-pages")
  footer.el.appendTo document.getElementById("footer-container")

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

  $("button[name='decision-tree-confirm-task']").html("Next Subject")

  $(".readymade-site-link").on "click", (e) ->
    $(@).addClass("active").siblings().removeClass("active")

  $("button#clouds-present").on "click", (e) ->
    $(@).toggleClass("present")

  $(".readymade-subject-viewer-container").append("<img class='left-image' src='http://placehold.it/520X390'>")
  $(".readymade-subject-viewer-container").append("<img class='right-image' src='http://placehold.it/520X390'>")

  $("button[name='decision-tree-confirm-task']").on "click", ->
     $(".marking-surface .frames").children().clone().addClass("left-image").appendTo(".readymade-subject-viewer-container")
