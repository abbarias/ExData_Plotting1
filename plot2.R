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


##Creates Plot 2
png(filename = "plot2.png")

dt <- elec$DateTime
ap <- elec$Global_active_power

plot(dt, ap, xlab = "" , ylab = "Global Active Power (kilowatts)", type = "l", axes = FALSE)
box()

point <- ymd(c("2007/2/1", "2007/2/2", "2007/2/3"))
dlabels <- as.vector(wday(point, label = TRUE))

axis(1, at=as.numeric(point), labels = dlabels)

axis(2, at= c(0,2,4,6), labels =TRUE)

dev.off()
