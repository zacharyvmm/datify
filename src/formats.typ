#import "utils.typ": first-letter-to-upper, pad, safe-slice
#import "translations.typ": month-name, day-name
#import "config.typ": default-date-lang

#let custom-date-format = (date, format, ..args) => {
  // Default values
  let lang = default-date-lang

  // Process variable arguments to extract lang
  for arg in args.pos() {
    if type(arg) == str {
      lang = arg
    }
  }

  // Take all the information, stock it and reformat it.
  let day = pad(date.day(), 2)
  let month = pad(date.month(), 2)
  let year = str(date.year())
  let weekday = date.weekday()

  let short-day = str(date.day())
  let short-month = str(date.month())
  let short-year = year.slice(-2)

  // Uses the name function to return name in the correct languages
  let full-day = day-name(int(weekday), lang)
  let full-month = month-name(int(month), lang)

  // Correct name for the language with and uppercase at the start
  let capitalized-day = first-letter-to-upper(full-day)
  let capitalized-month = first-letter-to-upper(full-month)

  // Correct name for the language fully written in uppercase
  let uppercase-day = upper(full-day)
  let uppercase-month = upper(full-month)

  // Short name for months, i.e January = Jan
  let short-month-name =  if full-month.len() > 3 { safe-slice(full-month, 3) } else { full-month }
  let short-capitalized-month-name =  if capitalized-month.len() > 3 { safe-slice(capitalized-month, 3) } else { capitalized-month }

  // Format the arg format in the right form and returns it.
  let formatted = format
    // Day formats
    .replace("DD", day)
    .replace("dD", short-day)
    .replace("day", full-day)
    .replace("Day", capitalized-day)
    .replace("DAY", uppercase-day)

    // Month formats
    .replace("MMMM", capitalized-month)
    .replace("MMM", short-capitalized-month-name)
    .replace("mmm", short-month-name)
    .replace("MM", month)
    .replace("mM", short-month)
    .replace("month", full-month)
    .replace("Month", capitalized-month)
    .replace("MONTH", uppercase-month)

    // Year formats
    .replace("YYYY", year)
    .replace("YY", short-year)

  return formatted
}
