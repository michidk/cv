#import "utils.typ": debugMode
#import "icons.typ": *
#import "date.typ": formatDate

#let header() = {
  stack(
    dir: ttb,
    spacing: 10pt,
    text(
      weight: "thin",
      size: 40pt,
      "Michael Lohr"
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

#let adress() = {
  set align(right)

  let head(body) = {
    text(
      weight: "bold",
      body
    )
  }

  let sep() = { v(0.5cm) }

  stack(
    dir: ttb,
    spacing: 5pt,
    image("data/picture.png", height: 3.5cm),
    v(0.3cm),
    head("Address"),
    text("Lessingstr. 5"),
    text("80336 München"),
    text("Germany"),
    sep(),
    head("Contact"),
    link("tel:004917685706626")[0176 85706626 #phone],
    link("mailto:michael@Lohr-ffb.de")[michael\@lohr-ffb.de #mail],
    sep(),
    head("Social"),
    link("https://linkedin.com/in/michael-lohr")[michael-lohr #linkedin],
    link("https://github.com/michidk")[michidk #github]
  )
}

#let template(
  data: none,
  debug: false,
  body
) = {
  set document(
    title: "Michael Lohr's CV",
    author: "Michael Lohr"
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

      smallcaps("Michael Lohr")
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
      #set text(16pt, weight: "bold")

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
      header()
      tagline[Because a Great Idea is Never Enough.]
      [
        = Summary
        #lorem(20)

        = Skills
        *Key Skills*
        #columns(3, gutter: 0.2cm)[
            - #lorem(2)
            - #lorem(3)
            #colbreak()
            - #lorem(2)
            - #lorem(3)
            #colbreak()
            - #lorem(2)
            - #lorem(3)
          ]

        *Technical Skills*
        - #lorem(2): #lorem(7)
        - #lorem(2): #lorem(6)
        - #lorem(2): #lorem(7)
        - #lorem(2): #lorem(5)
        - #lorem(2): #lorem(6)
      ]
    },
    adress()
  )

  heading("Work Experience")
  for work in data.work {
    block(breakable: false,
    {
      grid(
        columns: 2,
        rows: 2,
        column-gutter: 1fr,
        row-gutter: 0.2cm,
        strong(work.name),
        {
          set align(right)
          if "endData" in work {
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
    grid(
    columns: 2,
    rows: 2,
    column-gutter: 1fr,
    row-gutter: 0.2cm,
    strong("AWS Certified Solutions Architect - Associate"),
    [Okt 2022],
    text(
      size: 10pt,
      weight: "medium",
      fill: rgb("#545454"),
      upper("Amazon Web Services")),
    text(
      size: 9pt,
      ligatures: false,
      overhang: false,
      kerning: false,
      emph("expired")
    )
  )


}
