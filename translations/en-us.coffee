module.exports =
  site:
    title: 'Floating Forests'
    summary: 'Discover Floating Forests'
    description: "We are trying to understand how forests of kelp grow and change over time. We need your help to find these forests in pictures from space!"
    callToAction: "Get Started"
    location: "All Locations"
    talkLink: "Discuss"
    blogLink: "Blog"

  classifyPage:
    next: "Next Image"
    summary:
      header: "Nice Work!"
      youMarked: "You Marked:"
      locatedNear: "Located Near:"
      talk: "Discuss on Talk"
    noMoreSubjects: """
      <h1>Nice Work!</h1>
      <p>We're all out of images to classify right now.</p>
      <p>Check out one of <a href="https://www.zooniverse.org/">our other projects</a> while we load up some more!</p>
    """

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
      waves: "Waves"
      land: "Land"
      faulty: "Faulty Image"
      summary: "Please mark images by tracing an outline around the perimeter of any visible kelp beds. If you see any clouds please indicate by clicking the clouds button."
      badImages: "If you see an image that is all land or appears faulty, please click 'Next Image' without making any marks and we will flag it for removal from the dataset. Waves do not need to be marked."
    locations:
      all: "All Locations"
      california: "California"
      tasmania: "Tasmania"
      delayMessage: "Location changes will take effect after the current queue of 5 images"

  tutorial:
    skip: "Skip"
    next: "Next"
    finish: "Finish"
    step1:
      header: "Welcome to Floating Forests"
      content: """This is a brief tutorial to guide you through the steps to classify on Floating Forests"""
    step2:
      header: "Basics of Marking"
      content: """To mark an area of kelp, simply click and drag your mouse on the image. When you release, any remaining gap will be filled in to make a complete polygon."""
    step3:
      header: "Removing Bad Marks"
      content: """You can remove a bad or accidental mark by clicking the mark, then pressing your delete key. You may also click “Undo” below to remove your last mark."""
    step4:
      header: "Identifying Clouds"
      content: """You may occasionally spot clouds obscuring the view of the coastline. When you see this, click the “Clouds Present” button below. Do mark any kelp you can see!"""
    step5:
      header: "Happy Hunting"
      content: """Thank you for your interest in Floating Forests! You can discuss the project with the science team and other volunteers by visiting Talk."""

  about:
    title: "About"
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
      p1: "As we discover interesting things within the data, we will update this section."
    getInvolved:
      header: "Get Involved"
      p1: "Join us in the hunt for Kelp. Are you ready?"
      callToAction: "Start Hunting"
    connect:
      header: "Connect"
      p1: "Follow the <a href=''>Floating Forests</a> Blog and <a href='https://twitter.com/floatingforests'>@floatingforests</a> to keep current with the latest results"

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
      blog: "Zooniverse Education Blog"
    other:
      nav: "Other"
      octonauts: "If you love the Octonauts, they love kelp forests!"
      octonauts2: "Another Octonauts Video!"
      tasmania: "Kelp Forests of Tasmania"
      scuba: "SCUBA Dive Kelp Forests in the Channel Islands"

  team:
    title: "Team"
    organizations:
      nav: "Organizations"
      keen:
        name: "KEEN"
        description: """
          The Kelp Ecosystem Ecology Network (KEEN) is a collection of marine scientists interested in assessing the impacts of global change on kelp forests throughout the world. 
          Kelp forests provide a tremendous array of ecosystem services to the world around them. Yet kelps are sensitive to a wide variety of impacts - shifts in climate, release of herbivores from overfishing, 
          competition from turf-algae fuelled by nutrient pollution, and more. We’re attempting to bring together experiments and observations to create a global understanding of the status, health, and future of 
          our planet’s kelp forest ecosystems.
        """
      santaBarbara:
        name: "Santa Barbara Coastal Long-Term Ecological Research Site"
        description: """
          The Santa Barbara Coastal Long Term Ecological Research Project (SBC) is housed at the University of California, Santa Barbara (UCSB) and is part of the National Science Foundation's (NSF) Long Term Ecological Research (LTER) Network. 
          The LTER Program was established by the NSF in 1980 to support research on long-term ecological phenomena. SBC became the 24th site in the LTER network in April of 2000. 
          The primary research objective of the SBC LTER is to investigate the relative importance of land and ocean processes in structuring giant kelp forest ecosystems.
        """
      nceas:
        name: "National Center for Ecological Analysis and Synthesis"
        description: """
          Established in 1995, the National Center for Ecological Analysis and Synthesis (NCEAS) is a research center of the University of California, Santa Barbara and was the first national synthesis center of its kind. 
          There is broad acknowledgement that NCEAS has significantly altered the way ecological science is conducted, towards being more collaborative, open, integrative, relevant, and technologically informed. 
          Different from the scientific tradition of solitary lab or fieldwork, NCEAS fosters collaborative synthesis research – assembling interdisciplinary teams to distill existing data, ideas, theories, 
          or methods drawn from many sources, across multiple fields of inquiry, to accelerate the generation of new scientific knowledge at a broad scale.
        """

    scientists:
      nav: "Scientists"
      kyle:
        name: "Dr. Kyle Cavanaugh"
        description: """
          Kyle Cavanaugh is currently a postdoctoral researcher at the Smithsonian Environmental Research Center.  His research examines how coastal ecosystems respond to climate variability and direct human impacts. 
          Kyle likes to observe coastal ecosystems from a variety of perspectives: under the sea, waist deep in a mangrove swamp, or via a satellite orbiting 700 km above the earth. 
          Dr. Cavanaugh received his Ph.D. in Marine Science from the University of California, Santa Barbara.  In the Fall of 2014 he will be moving back to the west coast to start as an assistant professor in the Geography department at UCLA.
        """
      jarrett:
        name: "Dr. Jarrett Byrnes"
        description: """
          Dr. Byrnes is an assistant professor of Biology at the University of Massachusetts Boston. An East Coast native, he began working in the rolling lush kelp meadows of New England. He nearly choked on his regulator the first time he found himself 
          in a California Giant Kelp Forest while a Ph.D. student at UC Davis working in Bodega Bay. He’s spent the past decade working in a variety of kelp ecosystems, trying to understand how these incredible algae shape marine life in some of the most 
          heavily populated coastlines around the world.
        """
      alejandro:
        name: "Dr. Alejandro Pérez-Matus"
        description: """
          Dr. Perez-Matus is a research biologist and post doc at the Estacion Costera de Investigaciones Marinas (ECIM)-Pontificia Universidad Catolica de Chile. He has been diving in kelp forest taking underwater images and conducting research. 
          Fascinated by fishes associated to Giant Kelp plants he has work on different services that kelp give to fishes such as habitat for early stages, food and refuge from predation. On the other hand, fish provides benefits to kelp by 
          a) control grazers outbreaks, b) nutrients and c) dispersal of spores (kelp seeds) by herbivorous fishes. Understanding these feedbacks between kelp and fishes are important to understand dynamics of the community and their mutual benefits. 
        """
      andrew:
        name: "Dr. Andrew Rassweiler"
        description: """
          Dr. Rassweiler is a research biologist at the University of California Santa Barbara.  He is fascinated by Giant Kelp plants.  They are as physically imposing and important for structuring ecological communities as trees in a terrestrial forest, but they change so fast. 
          A Giant Kelp forest can disappear in a single storm, remain absent  for months or years and then fully reappear in a few months of explosive growth. Dr. Rassweiler has worked to better understand these dynamics by studying the physical and biological factors that affect kelp growth and survival.
        """
      alison:
        name: "Dr. Alison Haupt"
        description: """
          Dr. Haupt is a postdoctoral fellow with Jarrett Byrnes at the University of Massachusetts Boston.  Alison was born and raised in Monterey, CA where she learned to dive and became captivated by the giant kelp forests of the west coast. 
          This early introduction led her to explore kelp forests on the east and west coasts of the United States, Mexico, and Chile.  Alison is currently interested in how coastal development and urbanization might affect near-shore kelp forests as a postdoc at UMB, 
          but next year she’ll be returning to California to start as an assistant professor in the Science and Environmental Policy Division at CSU Monterey Bay. 
        """
      jorge:
        name: "Dr. Jorge Assis"
        description: """
          Dr. Assis’s research is mainly focused on identifying the environmental drivers shaping species distributions, to assess range dynamics for past and future times and to discuss the influences of range contractions and expansions on the global gene pool of species. 
          These questions have been addressed for kelp and fucoid species using modeling technics at multiple scales, seascape ecology and seascape genetics. His work is also centered on scientific communication and community participation projects. 
          He has conducted many outreach projects at national scales and promoted networks of volunteers in helping scientists gathering valuable data.
        """
      tom:
        name: "Tom Bell"
        description: """
          Tom Bell is Ph.D. candidate in the Marine Science program at the University of California, Santa Barbara. Tom was born in Southern California, but has spent much time researching how photosynthetic organisms respond to their environment in Baja California, Mexico and French Polynesia. 
          Currently, his research is focused on using remotely sensed images to study how giant kelp changes through time and space and how we can better understand this beautiful and important foundation species.
        """

    developers:
      nav: "Developers"

      alex:
        name: "Alex Weiksnar"
        description: """
          Developer, Zooniverse
        """

      heath:
        name: "Heath Van Singel"
        description: """
          Designer, Zooniverse
        """

      julie:
        name: "Julie Feldt"
        description: """
          Zooniverse Educator, Zooniverse
        """

      laura:
        name: "Laura Whyte"
        description: """
          Director of Citizen Science, Adler Planetarium, Zooniverse
        """
