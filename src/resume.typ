#import "template/mod.typ": *

#show: template.with(
  data: json("../data/resume.json"),
  displayTagline: true,
  displaySummary: true,
  importanceFilter: 2, // filter everything that is less important than 2
  debug: false
)
