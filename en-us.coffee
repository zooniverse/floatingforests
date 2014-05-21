module.exports =
  site:
    title: 'Kelp Hunters'
    summary: 'Help find kelp forests'
    description: """Join the search of satellite imagery to locate and track the worlds kelp forests!"""
    callToAction: "Get Started"
    location: "Location"

  homeSecondary: 
    header: "Why is kelp so great?"
    p1: """
      Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. 
      Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, 
      consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, 
      nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?
    """

  classifyPage:
    next: "Next Subject"
    summary:
      header: "Nice Work!"
      youMarked: "You Marked:"
      locatedNear: "Located Near:"
      talk: "Discuss on Talk"

  classifyMenu:
    tab:
      tutorial: "View Tutorial"
      fieldGuide: "Open Field Guide"
      location: "Change Location"
      favorites: "Add to Favorites"
      favorited: "Favorited"
    content:
      fieldGuide: "Field Guide"
      kelp: "Kelp"
      clouds: "Clouds"
    locations:
      all: "All Locations"
      california: "California"
      tasmania: "Tasmania"

  tutorial:
    skip: "Skip"
    next: "Next"
    finish: "Finish"
    step1:
      header: "Welcome to Kelp Hunters"
      content: """This is a brief tutorial to guide you through the steps to classify on Kelp Hunters"""
    step2:
      header: "Basics of Marking"
      content: """To mark an area of kelp, simply click and drag your mouse on the image. When you release, any remaining gap will be filled in to make a complete polygon."""
    step3:
      header: "Removing Bad Marks"
      content: """You can remove a bad or accidental mark by clicking the mark, then pressing your delete key. You may also click “Undo” below to remove the last mark you did."""
    step4:
      header: "Identifying Clouds"
      content: """You may occasionally spot clouds obscuring the view of the coastline. When you see this, click the “Clouds Present” button below. Do mark any kelp you can see!"""
    step5:
      header: "Happy Hunting"
      content: """Thank you for your interest in Kelp Hunters! You can discuss the project with the science team and other volunteers by visiting Talk."""

  about:
    title: "About Kelp"
    overview: 
      nav: "Overview"
      header: "Kelp Overview"
      p1: """
        Giant kelp forests produce a dense floating canopy that is clearly visible on Landsat satellite imagery. 
        Landsat Thematic Mapper (TM) imagery is freely available to the public and provides global coverage every ~16 days from 1984-present. 
        By providing classifications of changes in kelp canopy cover over the past 30 years on global scales, this project will identify regions where kelp forests have experience significant long-term changes. 
        We will then identify the likely environmental and anthropogenic drivers of these observed changes.
      """
      p2: """
        There is currently no long-term data on kelp canopy changes for most of the globe, so obtaining reliable classifications for any region (South Africa, Tasmania, New Zealand), 
        would be a substantial improvement over our current data. Our ultimate goal would be to obtain global coverage over the entire Landsat TM time series (1984-present).
      """
    task: 
      nav: "Your Task"
      header: "What is your task?"
      p1: """
        You are asked to trace the outline of giant kelp forests on Landsat satellite imagery. Kelp forests are highly distinctive on these images and we believe that by showing
        a few images of example forests, you will be able to identify forests without any specialist knowledge.
      """
      p2: """
        There are currently many automated processing routines available for classifying satellite imagery. We have experimented with many of these, however they are not well suited for the nearshore coastal environment. 
        Landsat was developed for terrestrial vegetation. The signal from floating aquatic vegetation is much weaker than that of terrestrial vegetation, and so we are working on the edge of Landsat’s signal to noise capabilities. 
        High variability in nearshore conditions (e.g. clouds, sunglint, turbidity) complicates the situation. All of the automated processing routines we have used require extensive manual editing to produce an acceptable product.
      """
    goals: 
      nav: "Goals"
      header: "Goals"
      p1: """This will be the goals section"""
    results: 
      nav: "Results"
      header: "Results"
      p1: """This will be the results section"""
    getInvolved:
      header: "Get Involved"
      p1: "Join us in the hunt for Kelp. Are you ready?"
      callToAction: "Start Classifying"
    connect:
      header: "Connect"
      p1: "Follow the <a href=''>Kelp Hunters</a> Blog and <a href=''>@kelp_hunters</a> to keep current with the latest results"
