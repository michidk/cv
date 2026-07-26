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

// sort a list of entries by date, most recent first
// ongoing entries (no endDate) always appear above ended ones;
// within each group, sort by the relevant date descending
#let sortDateRange(entry) = {
  if "endDate" in entry {
    "0" + entry.endDate  // ended: sort by end date
  } else {
    "1" + entry.startDate  // ongoing: sort by start date, always above ended
  }
}
