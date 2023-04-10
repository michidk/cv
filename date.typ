
#let months = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

// Parses ISO8601 dates to our custom format
// Needed until https://github.com/typst/typst/issues/303 is implemented
#let formatDate(date) = {
  let components = date.split("-")
  let year = components.at(0)
  let month = months.at(int(components.at(1)) - 1)
  [#month #year]
}
