#import "template/mod.typ": *

#show: template.with(
  data: json("../data/resume.json"),
  displayMugshot: true,
  debug: false
)
