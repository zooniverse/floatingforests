###
Secondary Page SubNav Usage

1. Create a nav with class="sub-nav-PAGE_NAME"
    ex: "science", "education"

2. Add buttons to the nav with name="SECTION_NAME"
    ex: "planets", "more-info", etc.

3. Add content sections with class="sub-nav-PAGE_NAME-SECTION_NAME"

4. The first child button and content section will be the default active
###

class SubNav
  constructor: (pageName) -> @createSubNav(pageName)

  createSubNav: (pageName) ->
    setTimeout =>
      initialPageBtn = $(".sub-nav-#{pageName} button:nth-child(1)").addClass("active")
      initialClassName = initialPageBtn.attr('name')

      $(".sub-nav-#{pageName}-#{initialClassName}:nth-child(1)").siblings().hide()

      $(".sub-nav-#{pageName} button").on "click", (e) =>
        $(".sub-nav-#{pageName}-#{e.target.name}").show().siblings().hide()
        $(".sub-nav-#{pageName} button[name=#{e.target.name}]").addClass("active").siblings().removeClass("active")

module?.exports = SubNav
