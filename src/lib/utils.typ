// enables the debug mode, which has some useful visualizations
#let debugMode(
  enabled: false,
  margins: (top: 0, bottom: 0, left: 0, right: 0),
  it
) = {
  if enabled {
    set block(stroke: red)
    let debugText = text(fill: red, size: 20pt, "DEBUG")
    context {
      for i in range(6) {
        place(top, dx: (measure(debugText).width + 1cm) * i, {
          v(-margins.top)
          debugText
        })
      }
    }
    it
  } else {
    it
  }
}

// prettify url by removing the protocol, www and trailing slash
#let prettifyUrl(url) = {
  url.replace("https://", "").replace("http://", "").replace("www.", "").trim("/", at: end)
}

// sort a list of entries by start date, most recent first
#let sortDateRange(entry) = {
  // sort by end date, if not present, put it at the beginning and sort by start date
  // rationale: we want all "present" position on top, with the most recent ones on top
  if "endDate" in entry {
    entry.endDate
  } else {
    entry.startDate
  }
}
