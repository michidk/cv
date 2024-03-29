#import "../lib/utils.typ": debugMode, prettifyUrl, get, sortDateRange
#import "../lib/icons.typ": icons
#import "../lib/date.typ": formatDate
#import "section.typ": setupSectionHeading, experience, education, certifications, interests
#import "color.typ": colors

#let header(name) = {
  stack(
    dir: ttb,
    spacing: 10pt,
    text(
      weight: "thin",
      size: 40pt,
      name
    ),
    {
      h(0.5cm)
      text(
      size: 12pt,
      "Curriculum Vitae"
      )
    }
  )
}

#let tagline(content) = {
  set align(center)
  set text(lang: "de", size: 11pt) // to get that more stylized quote look
  set smartquote(enabled: true, double: true)

  block(above: 0.9cm, below: 0.4cm, emph["#content"])
}

#let adress(basics) = {
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
      size: 10pt,
    )
    let label = get(profile, "username", prettifyUrl(profile.url))
    link(profile.url, icons.at(profile.icon) + " " + label)
  }

  stack(
    dir: ttb,
    spacing: 5pt,
    image("../../data/" + basics.image, height: 3.5cm),
    v(0.3cm),
    head("Address"),
    text("Lessingstr. 5"),
    text("80336 München"),
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

#let template(
  data: none,
  markExpiredCertificates: true,
  debug: false,
  body
) = {
  let name = data.basics.name

  set document(
    title: name + "'s CV",
    author: name,
  )
  let margins = (
    top: 1cm,
    bottom: 1cm,
    left: 1cm,
    right: 1cm
  );
  set page(
    margin: margins,
    footer: {
      set align(center)
      set text(
        size: 8pt,
        weight: "medium",
        fill: rgb("#c0bdbd")
      )

      smallcaps(name)
      h(0.2cm)
      sym.dot.c
      h(0.2cm)
      smallcaps("Curriculum Vitae")
    }
  )
  set text(
    font: "Roboto",
    size: 10pt
  )
  set list(
    indent: 0.15cm,
    body-indent: 0.1cm,
  )
  show link: set text(fill: colors.link)
  show columns: set block(above: 0.25cm) // fix for: https://github.com/typst/typst/issues/686

  // stylized headings
  show heading.where(level: 1): setupSectionHeading

  // debug mode
  show: debugMode.with(enabled: debug, margins: margins)

  grid(
    columns: (16fr, 5fr),
    gutter: 1cm,
    {
      header(name)
      tagline(data.basics.label)
      [
        = Summary
        #data.basics.summary

        = Skills
        #let keySkills = data.skills.filter(skill => "key" in skill and skill.key)
        #let skills = data.skills.filter(skill => not ("key" in skill and skill.key)).map(skill => (get(skill, "title", skill.name), get(skill, "subskills", ()).join(", ")))
        *Key Skills*
        #box(height: 1cm,
          columns(3, gutter: 0.2cm,
            list(..keySkills.map(skill => skill.name))
          )
        )

        *Technical Skills*
        #for skill in skills {
          if skill.at(1) != none {
            list(skill.at(0) + ": " + skill.at(1))
          } else {
            list(skill.at(0))
          }
        }
      ]
    },
    adress(data.basics)
  )

  experience(
    data.work.sorted(key: sortDateRange).rev(),
    "Work Experience"
  )

  education(
    data.education.sorted(key: e => sortDateRange(e)).rev()
  )

  certifications(
    data.certificates.sorted(key: cert =>
      cert.startDate
    ).rev(),
    markExpired: markExpiredCertificates
  )

  experience(
    data.volunteer.sorted(key: sortDateRange).rev(),
    "Volunteering"
  )

  interests(data.interests)

}
