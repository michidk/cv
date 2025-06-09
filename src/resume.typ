#import "template/mod.typ": *

#show: template.with(
  data: json("../data/resume.json"),
  title: "Résumé",
  displayTagline: true,
  displaySummary: true,
  importanceFilter: 2, // filter out everything that is less important than 3
  debug: false
)
