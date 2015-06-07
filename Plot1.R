##Downloading the data, setting the working directory, getting necessary packages
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(URL, destfile ="./electricpower.zip")
unzip("./electricpower.zip", exdir = "electric")
setwd("./electric")
require(sqldf)
require(lubridate)

##Tidying the Data
##Reading the data into R
elec <- read.csv.sql("household_power_consumption.txt", sql = "select * from file where Date in ('1/2/2007', '2/2/2007')", 
                     header = TRUE, sep= ";", 
                     colClasses=c("character", "character", "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", "numeric"))

##Getting a DateTime Column
elec$DateTime <- dmy_hms(paste(elec$Date, elec$Time, sep = " "))

##Getting a Day of Week Column
elec$Day <- wday(elec$DateTime, label = TRUE)


##Creates Plot 1
png(filename = "plot1.png")

x <- elec$Global_active_power
hist(x, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)", axes = FALSE)

axis(2, at = c(0, 200, 400, 600, 800, 1000, 1200), labels = TRUE)
axis(1, at= c(0,2,4,6), labels =TRUE)

dev.off()

