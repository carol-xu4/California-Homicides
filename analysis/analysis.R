## Preliminaries -----------------------------------------------------------
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, ggthemes, readxl, data.table, gdata, ipumsr)

# Set working directory 
setwd("C:/Users/CarolXu/OneDrive - Cato Institute/Desktop/California Homicides")

## ACS data ------------------------------------------------------------------
acs = fread("data/output/acs_california.csv")

# Cal-ViDa data --------------------------------------------------------------
cod = read_csv("data/output/calvida_cod.csv")

mod = read_csv("data/output/calvida_mod.csv")

# analysis -------------------------------------------------------------------

# CA total population
ca_pop = acs %>%
    group_by(year, immig_status) %>%
    summarize(
        n = n(),
        population = sum(perwt, na.rm = TRUE)) %>%
    ungroup() 

write_csv(ca_pop, "data/output/ca_population.csv")

# total homicides (manner of death)
mod_homicides = mod %>%
    filter(MOD == "Homicide") %>%
    group_by(year, nativity) %>%
    summarize(
        n = n(),
        homicides = sum(deaths, na.rm = TRUE)) %>%
    ungroup() %>%
    print(n = Inf)

# total homicides (cause of death)
    # COD: "Assault (homicide) by discharge of firearms"     
    # COD: "Assault (homicide) by other and unspecified means and their sequelae"
cod_homicides = cod %>% 
    filter(COD %in% c(
        "Assault (homicide) by discharge of firearms", 
        "Assault (homicide) by other and unspecified means and their sequelae")) %>%
    group_by(year, nativity) %>%
    summarize(
        n = n(),
        homicides = sum(deaths, na.rm = TRUE)) %>% 
    ungroup() %>%
    print(n = Inf)

# homicides (COD) per 100,000 population
acs_pop = acs %>%
    mutate(nativity = case_when(
        immig_status == "Native-born citizens" ~ "United States",
        immig_status %in% c("Legal immigrants", "Illegal immigrants") ~ "Foreign Born",
        TRUE ~ NA_character_)) %>%
    group_by(year, nativity) %>%
    summarize(population = sum(perwt, na.rm = TRUE), .groups = "drop")

cod_homicide_rates = cod_homicides %>%
    filter(nativity != "Unknown") %>%
    left_join(acs_pop, by = c("year", "nativity")) %>%
    mutate(rate_per_100k = homicides / population * 100000) %>%
    print(n = Inf)

write_csv(cod_homicide_rates, "data/output/cod_homicide_rates.csv")
