#import "utils.typ": debugMode, prettifyUrl, safeGet
#import "icons.typ": *
#import "date.typ": formatDate, isExpired

#let TODAY = "2023-04-15" // until https://github.com/typst/typst/issues/204 done

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
  set text(lang: "de") // to get that more stylized quote look
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
    let label = safeGet(profile, "username", prettifyUrl(profile.url))
    link(profile.url, icons.at(profile.icon) + " " + label)
  }

  stack(
    dir: ttb,
    spacing: 5pt,
    image("data/" + basics.image, height: 3.5cm),
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
    size: 11pt
  )
  set list(
    indent: 0.15cm,
    body-indent: 0.1cm,
  )
  show link: set text(fill: rgb("#0d3c88"))
  show columns: set block(above: 0.25cm) // fix for: https://github.com/typst/typst/issues/686
  // debug mode
  show: debugMode.with(enabled: debug, margins: margins)

  // stylized headings
  show heading.where(level: 1): content => {
    block(width: 100%, above: 0.5cm, below: 0.4cm)[
      #set text(16pt, weight: "bold", fill: rgb("#585858"))

      #place(
        dx: 0cm,
        dy: 0.395cm,
        rect(
          width: 100%,
          height: 6pt,
          fill: rgb("#81d4fa")
        )
      )
      #v(0.1cm)
      #h(0.25cm)
      #text(content.body)
    ]
  }

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
        #let skills = data.skills.filter(skill => not ("key" in skill and skill.key)).map(skill => (safeGet(skill, "title", skill.name), safeGet(skill, "subskills", ()).join(", ")))
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

  heading("Work Experience")
  for work in data.work.sorted(key: work =>
    // sort by end date, if not present, put it at the beginning and sort by start date
    // rationale: we want all "present" position on top, with the most recent ones on top
    if "endDate" in work {
      work.endDate
    } else {
      ("AAA" + work.startDate)
    }
  ).rev() {
    block(breakable: false,
    {
      grid(
        columns: 2,
        rows: 2,
        column-gutter: 1fr,
        row-gutter: 0.2cm,
        {if "url" in work {link(work.url, strong(work.name))} else {strong(work.name)}},
        {
          set align(right)
          if "endDate" in work {
            [#formatDate(work.startDate) #sym.dash.en #formatDate(work.endDate)]
          } else {
            [#formatDate(work.startDate) #sym.dash.en Present]
          }
        },
        text(
          size: 10pt,
          weight: "medium",
          fill: rgb("#545454"),
          spacing: 150%,
          tracking: 1.3pt,
          upper(work.position)),
          {
            set align(right)
            text(
              size: 9pt,
              ligatures: false,
              overhang: false,
              kerning: false,
              work.location
            )
          }
      )
      if "highlights" in work {
        for highlight in work.highlights {
          [- #highlight]
        }
      }
  })
  }

  heading("Certifications")
  for certificate in data.certificates.sorted(key: certificate => certificate.startDate).rev() {
    block(breakable: false,
    {
      grid(
        columns: 2,
        rows: 2,
        column-gutter: 1fr,
        row-gutter: 0.2cm,
        {if "url" in certificate {link(certificate.url, strong(certificate.name))} else {strong(certificate.name)}},
        {
          set align(right)
          if not markExpiredCertificates {
            if "endDate" in certificate {
              [#formatDate(certificate.startDate) #sym.dash.en #formatDate(certificate.endDate)]
            } else {
              [#formatDate(certificate.startDate) #sym.dash.en Present]
            }
          } else {
            [#formatDate(certificate.startDate)]
          }
        },
        text(
          size: 10pt,
          weight: "medium",
          fill: rgb("#545454"),
          upper(certificate.issuer)
        ),
        {
          set align(right)

          if "endDate" in certificate and markExpiredCertificates {
            if isExpired(certificate.endDate, TODAY) {
              text(
                size: 9pt,
                ligatures: false,
                overhang: false,
                kerning: false,
                emph("expired")
              )
            }
          }
        }
      )
  })
  }
}
