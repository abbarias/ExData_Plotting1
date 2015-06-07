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


##Creates Plot 4
png(filename = "plot4.png")
par(mfrow= c(2,2))


dt <- elec$DateTime
ap <- elec$Global_active_power
rp <- elec$Global_reactive_power
v <- elec$Voltage
point <- ymd(c("2007/2/1", "2007/2/2", "2007/2/3"))
dlabels <- as.vector(wday(point, label = TRUE))

with(elec, {
  ##plot1
  plot(dt, ap, xlab = "" , ylab = "Global Active Power (kilowatts)", type = "l", axes = FALSE)
  box()
  axis(1, at=as.numeric(point), labels = dlabels)
  axis(2, at= c(0,2,4,6), labels =TRUE)
  
  ##plot2
  plot(dt, v, xlab = "datetime" , ylab = "Voltage", type = "l", axes = FALSE)
  box()
  axis(1, at=as.numeric(point), labels = dlabels)
  axis(2, at= c(234,236,238,240,242,244,246), labels = c(234,"",238,"",242,"",246))
  
  ##plot3
  with(elec, plot(DateTime,Sub_metering_1, main = "", type ="n", xlab = "" , ylab = "Energy sub metering", axes = FALSE))
  with(elec, lines(DateTime,Sub_metering_1, type ="l",col = "black"))
  with(elec, lines(DateTime,Sub_metering_2, type ="l", col = "red"))
  with(elec, lines(DateTime,Sub_metering_3, type ="l", col = "blue"))
  box()
  axis(1, at=as.numeric(point), labels = dlabels)
  axis(2, at= c(0,10,20,30), labels =TRUE)
  legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
         lty = c(1,1), col = c("black", "red", "blue"), cex=0.9, bty = "n")
  
  ##plot4
  plot(dt, rp, xlab = "datetime" , ylab = "Global_reactive_power", type = "l", axes = FALSE)
  box()
  axis(1, at=as.numeric(point), labels = dlabels)
  axis(2, at= c(0.0,0.1,0.2,0.3,0.4,0.5), labels =TRUE)
})





dev.off()