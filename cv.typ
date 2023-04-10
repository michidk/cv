#import "template.typ": *

#show: template.with(
  data: json("data/resume.json"),
  debug: true
)
