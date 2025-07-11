#import "../lib/utils.typ": debugMode, prettifyUrl, get, sortDateRange
#import "../lib/icons.typ": icons
#import "../lib/date.typ": formatDate
#import "section.typ": setupSectionHeading, experience, education, certifications, interests
#import "color.typ": colors

#let header(name, subtitle, fontSizeAdjustment: 0pt) = {
  stack(
    dir: ttb,
    spacing: 10pt,
    text(
      weight: "thin",
      size: 40pt - fontSizeAdjustment,
      name
    ),
    {
      h(0.5cm)
      text(
        size: 12pt - fontSizeAdjustment,
        subtitle
      )
      v(0.2cm)
    },
  )
}

#let tagline(content, fontSizeAdjustment) = {
  set align(center)
  set text(lang: "de", size: 11pt - fontSizeAdjustment) // to get that more stylized quote look
  set smartquote(enabled: true, double: true)

  block(above: 0.3cm, below: 0.4cm, emph["#content"])
}

#let address(basics, displayMugshot: false, fontSizeAdjustment: 0pt) = {
  set align(right)

  let head(body) = {
    text(
      weight: "bold",
      body
    )
  }

  let sep() = { v(0.5cm) }

  let renderProfile(profile) = {
    set text(
      size: 10pt - fontSizeAdjustment,
    )
    let label = get(profile, "username", prettifyUrl(profile.url))
    link(profile.url, icons.at(profile.icon) + " " + label)
  }

  let mugshot = if displayMugshot {
    image("../../data/" + basics.image, height: 3.5cm)
  } else {
    v(1cm)
  }

  stack(
    dir: ttb,
    spacing: 5pt,
    mugshot,
    v(0.3cm),
    head("Address"),
    text(basics.location.address),
    text(basics.location.postalCode + " " + basics.location.city),
    text("Germany"),
    sep(),
    head("Contact"),
    link("tel:" + basics.phone)[#icons.phone #basics.phone],
    link("mailto:" + basics.email)[#icons.mail #basics.email],
    sep(),
    head("Web"),
    renderProfile((url: basics.url, username: "www.lohr.dev", icon: "globe")),
    ..basics.profiles.map(renderProfile)
  )
}

#let filterHighlights(entries, importanceFilter) = {
  if importanceFilter != none {
    entries.filter(e => e.keys().contains("importance") and e.importance > importanceFilter)
  } else {
    entries
  }
}

#let template(
  data: none,
  title: text,
  displayTagline: false,
  displaySummary: false,
  displayMugshot: false,
  displayInterests: true,
  displayVolunteering: true,
  importanceFilter: none,
  maxHighlights: none,
  hideDescriptions: false,
  markExpiredCertificates: true,
  margins: (top: 1cm, bottom: 1cm, left: 1cm, right: 1cm),
  fontSizeAdjustment: 0pt,
  squeeze: false,
  debug: false,
  body
) = {
  let name = data.basics.name

  set document(
    title: name + "'s CV",
    author: name,
  )
  set page(
    margin: margins,
    footer: {
      set align(center)
      set text(
        size: 8pt - fontSizeAdjustment,
        weight: "medium",
        fill: rgb("#c0bdbd")
      )
      smallcaps(name)
      h(0.2cm)
      sym.dot.c
      h(0.2cm)
      smallcaps(title)
    }
  )
  set text(
    font: "Roboto",
    size: 10pt - fontSizeAdjustment
  )
  set list(
    indent: 0.15cm,
    body-indent: 0.1cm,
  )
  show link: set text(fill: colors.link)
  show columns: set block(above: 0.25cm) // fix for: https://github.com/typst/typst/issues/686

  // stylized headings
  show heading.where(level: 1): content => setupSectionHeading(content, fontSizeAdjustment, squeeze: squeeze)

  // debug mode
  show: debugMode.with(enabled: debug, margins: margins)

  grid(
    columns: (16fr, 5fr),
    gutter: 1cm,
    {
      header(name, title, fontSizeAdjustment: fontSizeAdjustment)
      if displayTagline { tagline(data.basics.label, fontSizeAdjustment) }
      if displaySummary {
        [
          = Summary
          #data.basics.summary
        ]
      }
      [
        = Skills
        #set list(spacing: 0.6em)
        #set par(spacing: if squeeze { -0.4em } else { 0.8em })
        #let keySkills = data.skills.filter(skill => "key" in skill and skill.key)
        #let skills = data.skills.filter(skill => not ("key" in skill and skill.key)).map(skill => (get(skill, "title", skill.name), get(skill, "subskills", ()).join(", ")))
        *Key Skills*
        #box(height: 0.8cm,
          columns(3, gutter: 0.2cm,
            list(..keySkills.map(skill => skill.name)),
          )
        )

        *Technical Skills*
        #for skill in skills {
          if skill.at(1) != none [
            - #skill.at(0): #skill.at(1)
           ] else [
            - #skill.at(0))
           ]
        }
      ]
    },
    address(data.basics, displayMugshot: displayMugshot, fontSizeAdjustment: fontSizeAdjustment)
  )

  let workData = filterHighlights(data.work, importanceFilter)
  experience(
    workData.sorted(key: sortDateRange).rev(),
    "Work Experience",
    hideDescriptions,
    maxHighlights,
    fontSizeAdjustment,
    squeeze: squeeze
  )

  let educationData = filterHighlights(data.education, importanceFilter)
  education(
    educationData.sorted(key: sortDateRange).rev(),
    hideDescriptions,
    maxHighlights,
    fontSizeAdjustment,
    squeeze: squeeze
  )

  let certificationsData = filterHighlights(data.certificates, importanceFilter)
  certifications(
    certificationsData.sorted(key: cert =>
      cert.startDate
    ).rev(),
    hideDescriptions,
    fontSizeAdjustment,
    markExpired: markExpiredCertificates,
    squeeze: squeeze
  )

  if displayVolunteering {
    let volunteerData = filterHighlights(data.volunteer, importanceFilter)
    experience(
      volunteerData.sorted(key: sortDateRange).rev(),
      "Volunteering",
      hideDescriptions,
      maxHighlights,
      fontSizeAdjustment,
      squeeze: squeeze,
    )
  }

  if displayInterests { interests(data.interests) }
}
