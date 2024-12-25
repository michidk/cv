#import "template/mod.typ": *

#show: template.with(
  data: json("../data/resume.json"),
  title: "Curriculum Vitae",
  debug: false
)
