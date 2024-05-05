// Parse ISO8601 dates
#let parseDate(dateStr) = {
  let components = dateStr.split("-")
  let year = int(components.at(0))
  let month = int(components.at(1))
  let day = int(components.at(2))

  datetime(
    year: year,
    month: month,
    day: day
  )
}

#let months = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
#let formatDate(dateStr, onlyYear: false) = {
  let date = parseDate(dateStr)

  if onlyYear {
    [#date.year()]
  } else {
    let month = months.at(int(date.month()) - 1)
    [#month #date.year()]
  }
}

#let hasExpired(dateStr) = {
  let date = parseDate(dateStr)
  let today = datetime.today()

  if date.year() < today.year() {
    return true
  } else if date.year() == today.year() {
    return date.ordinal() < today.ordinal()
  } else {
    return false
  }
}
