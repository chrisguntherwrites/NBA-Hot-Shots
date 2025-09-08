library(dplyr)
library(hoopR)

# Get shooting stats
all_shooting_splits <- nba_leaguedashplayerptshot(
  league_id = '00', 
  season = "2024-25",
  season_type = "Regular Season"
)
all_shooting_splits <- all_shooting_splits$LeagueDashPlayerPTShot

# Extract relevant columns 
hot_shots_df <- all_shooting_splits %>% select(
  PLAYER_NAME, 
  PLAYER_LAST_TEAM_ABBREVIATION, 
  G, 
  FG3A_FREQUENCY, 
  FG3M, 
  FG3_PCT)

# Add today's date
today = Sys.Date()
today_str <- format(Sys.Date(), "%Y-%m-%d")
hot_shots_df <- hot_shots_df %>% mutate(date = today)

# Save to CSV
filename <- paste0("nba_hot_shots_", today_str, ".csv")
write.csv(hot_shots_df, filename, row.names = FALSE)

cat("Saved NBA player shooting stats to", filename, "\n")
