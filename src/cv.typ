#import "template/mod.typ": *

#let TODAY = "2023-04-22" // until https://github.com/typst/typst/issues/204 done

#show: template.with(
  data: json("../data/resume.json"),
  today: TODAY,
  debug: false
)
