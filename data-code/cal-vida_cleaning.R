# read in cause of death
calvida_cod = read_csv("data/input/Cal-ViDa_Death_09022026.csv")

# read in manner of death
calvida_mod = read_csv("data/input/Cal-ViDa_Death_09022026 (1).csv")

# remove unnecesary columns & rename
calvida_cod = calvida_cod %>%
    rename(
        year = "Year_of_Death",
        nativity = "US_or_Foreign_Born",
        COD = "Cause_of_Death",
        deaths = "Total_Deaths") %>%
    select(year, nativity, COD, deaths)

calvida_mod = calvida_mod %>%
    rename(
        year = "Year_of_Death",
        nativity = "US_or_Foreign_Born",
        MOD = "Manner_of_Death",
        deaths = "Total_Deaths") %>%
    select(year, nativity, MOD, deaths)

# change suppressed <11 death counts to midpoint (5)
calvida_cod = calvida_cod %>%
    mutate(deaths = ifelse(deaths == "<11", 5, deaths)) %>%
    mutate(deaths = as.numeric(deaths))

calvida_mod = calvida_mod %>%
    mutate(deaths = ifelse(deaths == "<11", 5, deaths)) %>%
    mutate(deaths = as.numeric(deaths))

# write final datasets
write_csv(calvida_cod, "data/output/calvida_cod.csv")

write_csv(calvida_mod, "data/output/calvida_mod.csv")
