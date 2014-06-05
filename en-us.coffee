module.exports =
  site:
    title: 'Kelp Hunters'
    summary: 'Discover Floating Forests'
    description: "We are trying to understand how forests of kelp grow and change over time. We need your help to find these forests in pictures from space!"
    callToAction: "Get Started"
    location: "All Locations"

  homeSecondary: 
    header: "Why is kelp so great?"
    p1: """
      Giant kelp forests produce a dense floating canopy that is clearly visible on Landsat satellite imagery. 
      Landsat Thematic Mapper (TM) imagery is freely available to the public and provides global coverage every ~16 days from 1984-present. 
      By providing classifications of changes in kelp canopy cover over the past 30 years on global scales, this project will identify regions where kelp forests have experience significant long-term changes. 
      We will then identify the likely environmental and anthropogenic drivers of these observed changes.
    """

  classifyPage:
    next: "Next Image"
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
    title: "About Kelp Hunters"
    overview: 
      nav: "Overview"
      header: "Overview"
      p1: """
        Welcome to Floating Forests, where we ask you to help us uncover the history of Giant Kelp forests around the globe. Most algae and animals that live on the seafloor can only be sampled by SCUBA divers or dredging up samples from the deep. This kind of data requires a ton of (really fun) effort to collect, but it means we’re limited in our knowledge of changes in their abundances through time. But Giant Kelp is amazing - it can grow up to a foot a day and forms lush canopies that can be seen by some of the earliest satellites man put into space!
      """

      whyImportant: "Why is kelp important?"
      whyImportantP: """
      Kelp is what we call a ‘foundation species’. In ecosystems where it is present (roughly 25% of the world’s coastlines!) it is the foundation of the entire ecosystem. It provides food for all manner of herbivores from tiny shrimp to ravenous sea urchins to grazing fish. Speaking of fish, it provides habitat and hiding places for fish and other organisms on the seafloor. It can dampen coastal waves as they sweep in towards shore. And it provides alginate and other ingredients that we find in many household products from cosmetics to ice cream.
      Loss of kelp forests can have dire consequences for the health, resilience, and productivity of our coastal ecosystems.
      """

    task: 
      nav: "Your Task"
      header: "What am I looking for?"
      p1: """
        Quite simply, kelp! Giant Kelp (Macrocystis pyrifera)! The canopy of these floating forests will show up in pictures as clusters of green pixels fringing the coastline (see image at right). Simply outline these forest canopies, and we’ll take it from there. We also hope that as you go through these pictures, you begin to see how coastlines of different areas around the world have changed over time.
      """

      whyPublic: "Why do we need your help?"
      whyPublicP: """
        The images you’re looking at come from Landsat images taken every 16 days from 1984 to the present. When one of our project scientists first began working with these images, he had hoped he could just throw the hundreds of thousands of images into some image classification software, and have the software tell him where kelp was located. There’s just one problem:
        <br><br>
        <strong>Kelp is tricky.</strong>
        <br><br>
        Landsat was not designed to be able to see kelp. Kelp’s reflectance signature is just at the edge of its detection abilities. Because of this, kelp and something as simple as the glint of sun off of a wave look the same to a computer. But to a person, the shapes and patterns of kelp forests are fairly obvious. That’s where you come in.
      """

      whatElse:
        "What else might I see?"
      whatElseP: """
        Well, first off, you might see *other* kelps. Some of the images we’ve included are from areas with both giant and other canopy forming kelps. To date, no one has looked at these pictures, and we really don’t know if we can use Landsat to count these other kelps, too. You might see debris lines, large ships, oil rigs, and many other interesting things. You’ll also see what areas of the coast look like around the world. Take a gander at the patterns of human habitation along developed coastline of California. Or look for interesting features on the islands just to the north of Antarctica. What do you see? Are there patterns relating to kelp? Is there something that intrigues you? Head on over to Talk and let us know about it.
      """

    goals: 
      nav: "Goals"
      header: "Goals"

      whatLearn: "What will we learn about kelp?"
      whatLearnP: """
      There is currently no long-term data on kelp canopy changes for most of the globe, so obtaining reliable classifications for any region (South Africa, Tasmania, New Zealand), would be a substantial improvement over our current data. Our ultimate goal would be to obtain global coverage over the entire Landsat time series (1984-present). This time period encompasses vast changes in ocean climate, coastal land-use, and human use of the sea around us.
      <br><br>
      By providing classifications of changes in kelp canopy cover over the past 30 years on global scales, this project will identify regions where kelp forests have experience significant long-term changes. We will then identify the likely environmental and human drivers of these observed changes.
      """

    results:
      nav: "Results"
      header: "Results"
      p1: "As we discover interesting things within the data, we will add"
    getInvolved:
      header: "Get Involved"
      p1: "Join us in the hunt for Kelp. Are you ready?"
      callToAction: "Start Hunting"
    connect:
      header: "Connect"
      p1: "Follow the <a href=''>Kelp Hunters</a> Blog and <a href=''>@kelp_hunters</a> to keep current with the latest results"

  education:
    title: "Education"
    overview:
      nav: "Overview"
      canIUse: "Can I use Floating Forests in the classroom?"
      canIUseP: """
        We would love you to! Floating Forests, just like all the Zooniverse projects, offers students a unique opportunity to explore real scientific data, while making a contribution to cutting edge research.
        <br><br> 
        We would like to stress that as each image is marked by multiple volunteers, it really does not matter if your students don't mark all the kelp beds perfectly. That being said, the task itself is simple enough that we believe most people can take part and make a worthwhile contribution regardless of age.
      """

      resources: "What resources are there to support use in the classroom?"
      resourcesP: """
        Our education portal, <a href="http://www.zooteach.org/">ZooTeach</a>, is the central repository for all our educational materials, including lesson plans and other resources.
        <br><br>
        Floating Forests is a recent addition, so if you have any idea's for how to use the project in the classroom, it would be great if you could share your lesson idea's or resources!
      """

      upToDate: "How can I keep up to date with education and Floating Forests?"
      upToDateP: """
        The Floating Forests blog is a great place to keep up to date with the latests science results. You can also check our archive of Google+ Hangouts on Air, or ask questions during our next HOA! For even more up to date info, follow us on Twitter at @FloatingForests. 
        There is also a Zooniverse Education Blog as well as a @zooteach Twitter feed.
      """
    resources:
      nav: "Resources"
      noaa: "NOAA’s introduction to kelp forests"
      channelOnce: "Bosques de Kelp from Channel Once"
      birch: "The Birch Aquarium’s excellent page"
      monterest: "The Monterest Bay National Marine Sanctuary"
      tasmania: "Tasmania’s Disappearing Kelp Forests"
    other:
      nav: "Other"
      octonauts: "If you love the Octonauts, they love kelp forests!"
      octonauts2: "Another Octonauts Video!"
      tasmania: "Kelp Forests of Tasmania"
      scuba: "SCUBA Dive Kelp Forests in the Channel Islands"
