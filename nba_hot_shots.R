library(httr)
library(jsonlite)
library(dplyr)

# NBA Stats API endpoint
url <- "https://stats.nba.com/stats/leaguedashplayerptshot"

# Query parameters
params <- list(
  Season = "2024-25",
  SeasonType = "Regular Season",
  DistanceRange = "16ft - 3pt",
  LeagueID = "00",
  MeasureType = "By Shooting Distance",
  PerMode = "Totals",
  PlayerExperience = "",
  PlayerPosition = "",
  PlusMinus = "N",
  Rank = "N",
  Outcome = "",
  PORound = "",
  Location = "",
  Month = "0",
  OpponentTeamID = "0",
  GameSegment = "",
  DateFrom = "",
  DateTo = "",
  TeamID = "0",
  VsConference = "",
  VsDivision = "",
  Division = "",
  Conference = ""
)

# Headers to mimic browser requests
headers <- c(
  "Host" = "stats.nba.com",
  "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
  "Accept" = "application/json, text/plain, */*",
  "Accept-Language" = "en-US,en;q=0.9",
  "Referer" = "https://www.nba.com/stats/players/shooting?DistanceRange=By+Zone&SeasonType=Regular+Season",
  "Origin" = "https://www.nba.com",
  "Connection" = "keep-alive",
  "x-nba-stats-origin" = "stats",
  "x-nba-stats-token" = "true"
)

# Fetch NBA 3-point stats function
fetch_nba_3pt_stats <- function() {
  response <- GET(url, query = params, add_headers(.headers = headers))
  stop_for_status(response)
  content_json <- content(response, "text", encoding = "UTF-8")
  content_data <- fromJSON(content_json, flatten = TRUE)
  headers_table <- content_data$resultSets[[2]][[1]]
  rows <- content_data$resultSets[[3]]
  df <- as.data.frame(do.call(rbind, rows), stringsAsFactors = FALSE)
  colnames(df) <- headers_table
  return(df)
}

df <- fetch_nba_3pt_stats()

# Add today's date as a column
today = Sys.Date()
df <- df %>% mutate(date = today)

# Save as CSV
today_str <- format(today, "%Y-%m-%d")
filename <- paste0("nba_hot_shots_", today_str, ".csv")
write.csv(df, filename, row.names = FALSE)
cat("Saved NBA 3-point shooting stats to", filename, "\n")
