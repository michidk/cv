#import "icons.typ": *


#let header() = {
  stack(
    dir: ttb,
    spacing: 10pt,
    text(
      weight: "thin",
      size: 40pt,
      "Michael Lohr"
    ),
    text(
      size: 15pt,
      "Curriculum Vitae"
    )
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

#let cv(
  test: none,
  body
) = {
  set document(
    title: "Michael Lohr's CV",
    author: "Michael Lohr"
  )
  set page(
    margin: (
      top: 1cm,
      bottom: 1cm,
      left: 1cm,
      right: 1cm
    ),
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
        #v(-0.2cm) //fix for: https://github.com/typst/typst/issues/686
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
  grid(
    columns: 2,
    rows: 2,
    column-gutter: 1fr,
    row-gutter: 0.2cm,
    strong("STABL Energy GmbH"),
    [Okt 2022 #sym.dash.en Present],
    text(
      size: 10pt,
      weight: "medium",
      fill: rgb("#545454"),
      spacing: 150%,
      tracking: 1.3pt,
      upper("Software Engineer")),
    text(
      size: 9pt,
      ligatures: false,
      overhang: false,
      kerning: false,
      "Munich"
    )
  )
  list(
    lorem(10),
    lorem(10),
    lorem(10),
    lorem(10),
    lorem(10),
  )

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
