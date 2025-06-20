# Code written by Aditya Kakde, owner of account @Onnamission

library(tidyverse)
library(janitor)
library(skimr)
library(lubridate)
library(readxl)


# Setting working directory

# print(getwd())
# setwd("D:/Projects/SpaceX-Analytics")
# print(getwd())

df = read_excel('Dataset/SpaceX-Missions.xlsx')

# View(df)


# Data Cleaning Pipeline

data_clean = df %>%
  janitor::clean_names()

# View(data_clean)

sapply(data_clean, class)


# converting data type in correct format

data_clean$payload_mass_kg = as.numeric(data_clean$payload_mass_kg)

data_clean$payload_mass_kg = round(data_clean$payload_mass_kg)

# View(data_clean)


# removing unnecessary columns

data_clean = subset(data_clean, select = -c(customer_name,
                                            payload_name,
                                            payload_orbit,
                                            launch_time))

# View(data_clean)


# Removing NA to 0 in payload_mass_kg and payload_type

data_clean$payload_mass_kg[is.na(data_clean$payload_mass_kg)] = 0

data_clean$payload_type[is.na(data_clean$payload_type)] = 0

data_clean$customer_type[is.na(data_clean$customer_type)] = 0

data_clean$customer_country[is.na(data_clean$customer_country)] = 0

# View(data_clean)


# Removing zeros from data frame

data_clean = filter(data_clean, 
                    length(flight_number) > 0,
                    length(launch_site) > 0,
                    length(vehicle_type) > 0,
                    length(payload_type) > 0,
                    payload_mass_kg > 0,
                    length(customer_type) > 0,
                    length(customer_country) > 0,
                    length(mission_outcome) > 0,
                    length(failure_reason) > 0,
                    length(landing_type) > 0,
                    length(landing_outcome) > 0)

# View(data_clean)


# Deleting 3rd row as 0 zeros got left.

data_clean = data_clean[-c(3), ]

# View(data_clean)


# renaming columns

colnames(data_clean) = c("flight_number",
                         "launch_date",
                         "launch_site",
                         "vehicle_type",
                         "payload_type",
                         "payload_mass",
                         "customer_type",
                         "customer_country",
                         "launch_outcome",
                         "failure_reason",
                         "landing_type",
                         "landing_outcome")

# View(data_clean)


# Success = 1 and Failure = 0 in col launch_outcome

data_clean$launch_outcome[data_clean$launch_outcome == "Success"] = 1

data_clean$launch_outcome[data_clean$launch_outcome == "Failure"] = 0

# View(data_clean)


# In landing_type, None in place of NA

data_clean$landing_type[is.na(data_clean$landing_type)] = "None"

data_clean$landing_type[data_clean$landing_type == "None"] = "Unknown"

# View(data_clean)


# Success = 1, Failure = 0, and NA = 0 in col landing_outcome

data_clean$landing_outcome[data_clean$landing_outcome == "Success"] = 1

data_clean$landing_outcome[data_clean$landing_outcome == "Failure"] = 0

data_clean$landing_outcome[is.na(data_clean$landing_outcome)] = 0

data_clean$landing_outcome[data_clean$launch_outcome == "Failure"] = 0

# View(data_clean)


# Replacing NA with No Failure in failure_reason as for success NA is given.

data_clean$failure_reason[is.na(data_clean$failure_reason)] = "No Failure"

# View(data_clean)


# Making a new col mission outcome

data_clean$mission_outcome = c(1:32)

data_clean$mission_outcome[data_clean$launch_outcome == 1 & data_clean$landing_outcome == 1] = 1

data_clean$mission_outcome[data_clean$launch_outcome == 0 & data_clean$landing_outcome == 1] = 0

data_clean$mission_outcome[data_clean$launch_outcome == 1 & data_clean$landing_outcome == 0] = 0

data_clean$mission_outcome[data_clean$launch_outcome == 0 & data_clean$landing_outcome == 0] = 0

# View(data_clean)


# Removing version number from vehicle_type

data_clean$vehicle_type[data_clean$vehicle_type == "Falcon 9 (v1.0)"] = "Falcon 9"

data_clean$vehicle_type[data_clean$vehicle_type == "Falcon 9 (v1.1)"] = "Falcon 9"

data_clean$vehicle_type[data_clean$vehicle_type == "Falcon 9 Full Thrust (v1.2)"] = "Falcon 9 Full Thrust"

# View(data_clean)


# Remove numbers from launch_site

data_clean$launch_site[data_clean$launch_site == "Cape Canaveral AFS LC-40"] = "Cape Canaveral"

data_clean$launch_site[data_clean$launch_site == "Vandenberg AFB SLC-4E"] = "Vandenberg"

data_clean$launch_site[data_clean$launch_site == "Kennedy Space Center LC-39A"] = "Kennedy Space Center"

# View(data_clean)


# Replacing values in flight_number with 1:32

data_clean$flight_number = c(1:32)

# View(data_clean)


# Assigning numbers to falcons for graphical analysis as per falcon rockets

data_clean$falcon_1 = c(data_clean$vehicle_type)

data_clean$falcon_1[data_clean$falcon_1 == "Falcon 1"] = 1

data_clean$falcon_1[data_clean$falcon_1 == "Falcon 9"] = 0

data_clean$falcon_1[data_clean$falcon_1 == "Falcon 9 Full Thrust"] = 0

# View(data_clean)


data_clean$falcon_9 = c(data_clean$vehicle_type)

data_clean$falcon_9[data_clean$falcon_9 == "Falcon 1"] = 0

data_clean$falcon_9[data_clean$falcon_9 == "Falcon 9"] = 1

data_clean$falcon_9[data_clean$falcon_9 == "Falcon 9 Full Thrust"] = 0

# View(data_clean)


data_clean$falcon_9_full_thrust = c(data_clean$vehicle_type)

data_clean$falcon_9_full_thrust[data_clean$falcon_9_full_thrust == "Falcon 1"] = 0

data_clean$falcon_9_full_thrust[data_clean$falcon_9_full_thrust == "Falcon 9"] = 0

data_clean$falcon_9_full_thrust[data_clean$falcon_9_full_thrust == "Falcon 9 Full Thrust"] = 1

# View(data_clean)


# Removing redundant data in payload_type

data_clean$payload_type[data_clean$payload_type == "Communication Satellite"] = "Communication/Research Satellite"

data_clean$payload_type[data_clean$payload_type == "Research Satellite"] = "Communication/Research Satellite"

data_clean$payload_type[data_clean$payload_type == "Research Satellites"] = "Communication/Research Satellite"

# View(data_clean)


# converting data type again

data_clean$launch_outcome = as.numeric(data_clean$launch_outcome)

data_clean$landing_outcome = as.numeric(data_clean$landing_outcome)

data_clean$falcon_1 = as.numeric(data_clean$falcon_1)

data_clean$falcon_9 = as.numeric(data_clean$falcon_9)

data_clean$falcon_9_full_thrust = as.numeric(data_clean$falcon_9_full_thrust)

# View(data_clean)


# writing changes to excel file

# write.csv(data_clean, "spacex.csv", row.names = FALSE)


