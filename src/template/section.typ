#import "color.typ": *
#import "../lib/date.typ": formatDate, hasExpired
#import "../lib/utils.typ": get

// sets up stylized section headings
#let setupSectionHeading(content, fontSizeAdjustment, squeeze: false) = {
  let above = if not squeeze { 0.5cm } else { 0.2cm }
  let below = if not squeeze { 0.5cm } else { 0.3cm }

  block(width: 100%, above: above, below: below, breakable: false)[
    #set text(
      16pt - fontSizeAdjustment,
      weight: "bold",
      fill: colors.heading,
      spacing: 150%,
      tracking: 1.2pt,
    )

    #place(
      dx: 0cm,
      dy: 0.3cm,
      rect(
        width: 100%,
        height: 6pt,
        fill: colors.accent,
      )
    )
    #if fontSizeAdjustment != 0pt { v(0.05cm) }
    #h(0.25cm)
    #text(content.body)
  ]
}

#let section(title, data, fnHeadLeft, fnHeadRight, fnBodyLeft, fnBodyRight, fnContent, fontSizeAdjustment: 0pt, squeeze: false) = {
  if not squeeze { v(0.25cm) }
  heading(title)
  for entry in data {
    block(
      breakable: false,
      above: if squeeze { 0.35em } else { 0.5em },
      below: 0.5em, // https://github.com/typst/typst/issues/686
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
    if squeeze { v(0.15cm) } else { v(0.25cm) }
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

#let entryLocation(entry, fontSizeAdjustment) = {
  if not "location" in entry {
    return
  }
  set align(right)
  text(
    size: 8pt - fontSizeAdjustment,
    ligatures: false,
    overhang: false,
    kerning: false,
    entry.location
  )
}

#let entryName(content, fontSizeAdjustment) = {
  text(
    size: 9pt - fontSizeAdjustment,
    weight: "medium",
    fill: colors.heading,
    upper(content)
  )
}

#let entryDateRange(entry, onlyYear: false) = {
  set align(right)
  if "startDate" in entry and "endDate" in entry {
    [#formatDate(entry.startDate, onlyYear: onlyYear) #sym.dash.en #formatDate(entry.endDate, onlyYear: onlyYear)]
  } else if "startDate" in entry {
    [#formatDate(entry.startDate, onlyYear: onlyYear) #sym.dash.en Present]
  } else if "endDate" in entry {
    formatDate(entry.endDate, onlyYear: onlyYear)
  }
}

#let entryContent(entry, hideDescriptions: false, maxHighlights: none) = {
  let dist = 0.4em
  set list(spacing: dist)
  set par(leading: dist)
  if "summary" in entry and not hideDescriptions {
    entry.summary
  }
  if "highlights" in entry {
    let capped_max = if maxHighlights != none {
      calc.min(maxHighlights, entry.highlights.len())
    } else {
      none
    }
    block(width: 100%, breakable: true, above: 0.7em)[
      #for highlight in entry.highlights.slice(0, capped_max) [
        - #highlight
      ]
    ]
  }
}


#let experience(works, title, hideDescriptions, maxHighlights, fontSizeAdjustment, squeeze: false) = {
  section(
    title,
    works,
    entryTitle,
    entryDateRange,
    entry => entryName(get(entry, "position", ""), fontSizeAdjustment),
    entry => entryLocation(entry, fontSizeAdjustment),
    entry => entryContent(entry, hideDescriptions: hideDescriptions, maxHighlights: maxHighlights),
    fontSizeAdjustment: fontSizeAdjustment,
    squeeze: squeeze
  )
}

#let education(edu, hideDescriptions, maxHighlights, fontSizeAdjustment, squeeze: false) = {
  section(
    "Education",
    edu,
    entryTitle,
    entry => entryDateRange(entry, onlyYear: true),
    entry => entryName({
      if "area" in entry {
        [#get(entry, "studyType", ""), #get(entry, "area", "")]
        if "score" in entry {
          [ -- Score: ]
          entry.score
        }
      }
    }, fontSizeAdjustment),
    entry => entryLocation(entry, fontSizeAdjustment),
    entry => entryContent(entry, hideDescriptions: hideDescriptions, maxHighlights: maxHighlights),
    fontSizeAdjustment: fontSizeAdjustment,
    squeeze: squeeze
  )
}

#let certifications(certs, hideDescriptions, fontSizeAdjustment, markExpired: true, squeeze: false) = {

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
      if hasExpired(entry.endDate) {
        text(
          size: 9pt - fontSizeAdjustment,
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
    entry => entryName(entry.issuer, fontSizeAdjustment),
    expired,
    none,
    squeeze: squeeze
  )
}

#let interests(interests) = {
  heading("Personal Interests")

  set list(spacing: 0.8em)
  let categories = interests.map(entry => entry.category).dedup()
  let content = for category in categories [
    - #interests.filter(entry => entry.category == category).map(entry => entry.name).join(", ")
  ]

  block(
    breakable: false,
    above: 0.5em,
    below: 0.5em,
    content
  )
}
