library(dplyr)
library(hoopR)

# Load the data for the 2024-25 NBA regular season shooting stats

## Get player IDs and names
nba_ids <- nba_commonallplayers(league_id = '00', season = year_to_season(most_recent_nba_season() - 1))
nba_ids <- nba_ids$CommonAllPlayers
nba_ids <- nba_ids %>% select(PERSON_ID, DISPLAY_FIRST_LAST)

all_shooting_splits <- nba_leaguedashplayerptshot(
  league_id = '00', 
  season = year_to_season(most_recent_nba_season() - 1)
)$LeagueDashPTShots

# Extract relevant columns 
hot_shots_df <- all_shooting_splits %>% select(
  PLAYER_NAME, 
  PLAYER_LAST_TEAM_ABBREVIATION, 
  G, 
  FG3A_FREQUENCY, 
  FG3M, 
  FG3_PCT)

# Add today's date
today_str <- format(Sys.Date(), "%Y-%m-%d")
hot_shots_df <- hot_shots_df %>% mutate(date = today)

# Save to CSV
filename <- paste0("nba_hot_shots_", today_str, ".csv")
write.csv(hot_shots_df, filename, row.names = FALSE)

cat("Saved NBA player shooting stats to", filename, "\n")
