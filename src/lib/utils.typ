// enables the debug mode, which has some useful visualizations
#let debugMode(
  enabled: false,
  margins: (top: 0, bottom: 0, left: 0, right: 0),
  it
) = {
  if enabled {
    set block(stroke: red)
    let text = text(fill: red, size: 20pt, "DEBUG")
    style(styles => {
      for i in range(6) {
        place(top, dx: (measure(text, styles).width + 1cm) * i, {
          v(-margins.top)
          text
        })
      }
    })
    it
  } else {
    it
  }
}

// prettify url by removing the protocol, www and trailing slash
#let prettifyUrl(url) = {
  let url = url.replace("https://", "").replace("http://", "").replace("www.", "")
  if url.ends-with("/") {
    url.slice(0, url.len() - 1)
  } else {
    url
  }
}

// safely get a value from a list, or return a default value
// needed until this is implemented: https://github.com/typst/typst/issues/946
#let get(list, key, default) = {
  if key in list {
    list.at(key)
  } else {
    default
  }
}

// sort a list of entries by start date, most recent first
#let sortDateRange(entry) = {
  // sort by end date, if not present, put it at the beginning and sort by start date
  // rationale: we want all "present" position on top, with the most recent ones on top
  if "endDate" in entry {
    entry.endDate
  } else {
    ("AAA" + entry.startDate)
  }
}
