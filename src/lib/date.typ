
#let months = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

// Parses ISO8601 dates to our custom format
// Needed until https://github.com/typst/typst/issues/303 is implemented
#let formatDate(date) = {
  let components = date.split("-")
  let year = components.at(0)
  let month = months.at(int(components.at(1)) - 1)
  [#month #year]
}

#let dateComponents(date) = {
  let components = date.split("-")
  let year = int(components.at(0))
  let month = int(components.at(1))
  let day = int(components.at(2))
  (year, month, day)
}

// Needed until https://github.com/typst/typst/issues/303 is implemented
#let isExpired(date, today) = {
  let components = date.split("-")
  let (year, month, day) = dateComponents(date)
  let (todayYear, todayMonth, todayDay) = dateComponents(today)
  if year < todayYear {
    true
  } else if year == todayYear {
    if month < todayMonth {
      true
    } else if month == todayMonth {
      day < todayDay
    } else {
      false
    }
  } else {
    false
  }
}
