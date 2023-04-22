#import "color.typ": *
#import "../lib/date.typ": formatDate, isExpired
#import "../lib/utils.typ": get

// sets up stylized section headings
#let setupSectionHeading(content) = {
  block(width: 100%, above: 0.5cm, below: 0.4cm)[
    #set text(16pt, weight: "bold", fill: colors.heading)

    #place(
      dx: 0cm,
      dy: 0.395cm,
      rect(
        width: 100%,
        height: 6pt,
        fill: colors.accent,
      )
    )
    #v(0.1cm)
    #h(0.25cm)
    #text(content.body)
  ]
}

#let section(title, data, fnHeadLeft, fnHeadRight, fnBodyLeft, fnBodyRight, fnContent) = {
  heading(title)
  for entry in data {
    block(
      breakable: false,
      grid(
        columns: 2,
        rows: 2,
        column-gutter: 1fr,
        row-gutter: 0.2cm,
        fnHeadLeft(entry),
        fnHeadRight(entry),
        fnBodyLeft(entry),
        fnBodyRight(entry),
      )
    )
    if fnContent != none {
      fnContent(entry)
    }
  }
}

#let entryTitle(entry) = {
  let title = if "name" in entry {
    entry.name
  } else if "organization" in entry {
    entry.organization
  } else if "institution" in entry {
    entry.institution
  } else {
    none
  }

  if "url" in entry {
    link(entry.url, strong(title))
  } else {
    if title != none {
      strong(title)
    }
  }
}

#let entryLocation(entry) = {
  if not "location" in entry {
    return
  }
  set align(right)
  text(
    size: 9pt,
    ligatures: false,
    overhang: false,
    kerning: false,
    entry.location
  )
}

#let entryName(content) = {
  text(
    size: 10pt,
    weight: "medium",
    fill: colors.heading,
    spacing: 150%,
    tracking: 1.3pt,
    upper(content)
  )
}

#let entryDateRange(entry) = {
  set align(right)
  if "startDate" in entry and "endDate" in entry {
    [#formatDate(entry.startDate) #sym.dash.en #formatDate(entry.endDate)]
  } else if "startDate" in entry {
    [#formatDate(entry.startDate) #sym.dash.en Present]
  } else if "endDate" in entry {
    formatDate(entry.endDate)
  }
}

#let entryContent(entry) = {
  if "summary" in entry {
    entry.summary
  }
  if "highlights" in entry {
    for highlight in entry.highlights {
      list(highlight)
    }
  }
}

#let experience(works, title) = {
  section(
    title,
    works,
    entryTitle,
    entryDateRange,
    entry => entryName(get(entry, "position", "")),
    entryLocation,
    entryContent
  )
}

#let education(edu) = {
  section(
    "Education",
    edu,
    entryTitle,
    entryDateRange,
    entry => entryName(get(entry, "area", "")),
    entryLocation,
    entryContent
  )
}

#let certifications(certs, today, markExpired: true) = {

  let date = entry => {
    set align(right)
    if not markExpired {
      if "endDate" in entry {
        [#formatDate(entry.startDate) #sym.dash.en #formatDate(entry.endDate)]
      } else {
        [#formatDate(entry.startDate) #sym.dash.en Present]
      }
    } else {
      [#formatDate(entry.startDate)]
    }
  }

  let expired = entry => {
    if "endDate" in entry and markExpired {
      if isExpired(entry.endDate, today) {
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

  section(
    "Certifications",
    certs,
    entryTitle,
    date,
    entry => entryName(entry.issuer),
    expired,
    none
  )
}
