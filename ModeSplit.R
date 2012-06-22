# Required libraries
require(ggplot2)
require(plyr)
require(reshape2)
require(googleVis)


### ACS convenience functions ###
# Could use acs.R, but data structures are a tad unwieldy to reshape; also divMOE function below yields lower margin of error but is not yet implemented
sumMOE <- function(marginsoferror) {
  # Sum margins of error
  moe <- sqrt(sum(marginsoferror^2))
  return(moe)
}

divMOE <- function(est1, moe1, est2, moe2) {
  # Divide margins of error (assume numerator part of denominator)
  # numerator / denominator
  p <- est1 / est2
  moe <- sqrt(moe1^2 - (p^2 * moe2^2)) / est2
  return(moe)
}


readData <- function(){
# Census ACS products dating back to 2006. I've pre-downloaded these due to the fact that American Factfinder 2 is terrible and I am too lazy to automate this now. In the future, this download can and should be automated.
# See http://www.census.gov/developers/ for information on the Census's future API
# Bookmarks for downloaded datasets
# 2006 1-year: http://factfinder2.census.gov/bkmk/table/1.0/en/ACS/06_EST/B08301/0500000US53035|3100000US42660
# 2007 1-year: http://factfinder2.census.gov/bkmk/table/1.0/en/ACS/07_1YR/B08301/0500000US53035|3100000US42660
# 2008 1-year: http://factfinder2.census.gov/bkmk/table/1.0/en/ACS/08_1YR/B08301/0500000US53035|3100000US42660
# 2009 1-year: http://factfinder2.census.gov/bkmk/table/1.0/en/ACS/09_1YR/B08301/0500000US53035|3100000US42660
# 2010 1-year: http://factfinder2.census.gov/bkmk/table/1.0/en/ACS/10_1YR/B08301/0500000US53035|310M100US42660

# Read estimates from 2006-2010
est6 <- read.csv("./DATA/ACS_06_EST_B08301_with_ann.csv", skip=7, header=FALSE)
est7 <- read.csv("./DATA/ACS_07_1YR_B08301_with_ann.csv", skip=7, header=FALSE)
est8 <- read.csv("./DATA/ACS_08_1YR_B08301_with_ann.csv", skip=7, header=FALSE)
est9 <- read.csv("./DATA/ACS_09_1YR_B08301_with_ann.csv", skip=7, header=FALSE)
est10 <- read.csv("./DATA/ACS_10_1YR_B08301_with_ann.csv", skip=7, header=FALSE)

# Set the year for each dataset
est6$year <- 2006
est7$year <- 2007
est8$year <- 2008
est9$year <- 2009
est10$year <- 2010

# Bind the data, dropping first two columns
est <- rbind(est6, est7, est8, est9, est10)

# Set the column names
# Define some standard column names for the various ACS transportation modes, and then set
censusnames <- c("GEOID", "GEOID2", "Geography", "Total", "Total.MOE", "Car truck or van", "CarTruckVan.MOE", "Drove alone", "DroveAlone.MOE", "Carpooled", "Carpooled.MOE", "Carpooled-2p", "Carpooled-2p.MOE", "Carpooled-3", "Carpooled-3.MOE", "Carpooled-4", "Carpooled-4.MOE", "Carpooled-5or6", "Carpooled-5or6.MOE", "Carpooled-7orMore", "Carpooled-7orMore.MOE", "Public transport", "PublicTransport.MOE", "Bus or trolleybus", "BusTrolleyBus.MOE", "Streetcar or trolleycar", "StreetcarTrolleyCar.MOE", "Subway elevated", "SubwayElevated.MOE", "Railroad", "Railroad.MOE", "Ferryboat", "Ferryboat.MOE", "Taxicab", "Taxicab.MOE", "Motorcycle", "Motorcycle.MOE", "Bicycled", "Bicycle.MOE", "Walked", "Walked.MOE", "Other means", "OtherMeans.MOE", "Worked at home", "WorkedAtHome.MOE", "year")

#censusnames <- c("GEOID", "GEOID2", "Geography", "Total", "MOE", "CarTruckVan", "MOE", "DroveAlone", "MOE", "Carpooled", "MOE", "Carpooled-2p", "MOE", "Carpooled-3", "MOE", "Carpooled-4", "MOE", "Carpooled-5or6", "MOE", "Carpooled-7orMore", "MOE", "PublicTransport", "MOE", "BusTrolleyBus", "MOE", "StreetcarTrolleyCar", "MOE", "SubwayElevated", "MOE", "Railroad", "MOE", "Ferryboat", "MOE", "Taxicab", "MOE", "Motorcycle", "MOE", "Bicycle", "MOE", "Walked", "MOE", "OtherMeans", "MOE", "WorkedAtHome", "MOE", "year")


colnames(est) <- censusnames

# Drop GEOID and GEOID2
est$GEOID <- NULL
est$GEOID2 <- NULL

est <- melt(est, id=c("Geography", "year"))

# Melting isn't perfect, need to separate errors 
e1 <- est[grep(".MOE", est$variable),]$value
est <- est[grep(".MOE", est$variable, invert=TRUE),]
est$MOE <- e1

# Add the Seattle-Tacoma-Bellevue MSA to Kitsap County
est <- ddply(est, c("variable", "year"), summarize, geography="CPS", estimate=sum(value), MOE=sumMOE(MOE))

# Format the data frame to make myself happy
est <- data.frame(geography=est$geography, mode=est$variable, estimate=est$estimate, MOE=est$MOE, year=est$year)

# Turn the year field into a date object
est$year <- as.Date(ISOdate(est$year, 1, 1))

return(est)
}

df <- readData()

### Calculate values as percent of total
# Add the totals to make dividing margins of error easier
df <- ddply(df, c("year", "mode", "estimate", "MOE"), summarize, totest=df$estimate[df$year==year & df$mode=="Total"], totmoe=df$MOE[df$year == year & df$mode=="Total"])

df <- ddply(df, c("year", "mode", "estimate", "MOE"), summarize, pctestimate = estimate / totest, pctMOE = divMOE(est1=estimate, moe1=MOE, est2=totest, moe2=totmoe))

# Create a proper percentage
df$pctestimate <- df$pctestimate * 100
df$pctMOE <- df$pctMOE * 100

### Subset the data
modesubset <- c("Drove alone", "Carpooled", "Public transport", "Bicycled", "Walked", "Worked at home")
df <- df[df$mode %in% modesubset, ]





##### PLOTS #####
pAllModes <- ggplot(df) +
  geom_ribbon(aes(x=year,
                  ymin=(pctestimate-pctMOE),
                  ymax=(pctestimate+pctMOE),
                  group=factor(mode)),
              alpha=.3) +
  geom_line(aes(x=year, y=pctestimate, color=factor(mode)), 
            size=1) +
  scale_color_brewer(type="qual", palette=2) +
  labs(y="Percent of commuters", color="Mode of Travel", group="Margin of Error")

pBicycled <- ggplot(df[df$mode %in% c("Bicycled"), ]) +
  geom_ribbon(aes(x=year,
                  ymin=(pctestimate-pctMOE),
                  ymax=(pctestimate+pctMOE)),
              alpha=.3) +
                geom_line(aes(x=year, y=pctestimate), size=1.5) +
                labs(y="Percent of commuters") +
                opts(title = expression("Percentage of commuters commuting by bicycle"))

pWalked <- ggplot(df[df$mode %in% c("Walked"), ]) +
  geom_ribbon(aes(x=year,
                  ymin=(pctestimate-pctMOE),
                  ymax=(pctestimate+pctMOE)),
              alpha=.3) +
                geom_line(aes(x=year, y=pctestimate), size=1.5) +
                labs(y="Percent of commuters") +
                opts(title = expression("Percentage of commuters commuting by walking"))

pCarpooled <- ggplot(df[df$mode %in% c("Carpooled"), ]) +
  geom_ribbon(aes(x=year,
                  ymin=(pctestimate-pctMOE),
                  ymax=(pctestimate+pctMOE)),
              alpha=.3) +
                geom_line(aes(x=year, y=pctestimate), size=1.5) +
                labs(y="Percent of commuters") +
                opts(title = expression("Percentage of commuters commuting by carpool"))

pPublicTransport <- ggplot(df[df$mode %in% c("Public transport"), ]) +
  geom_ribbon(aes(x=year,
                  ymin=(pctestimate-pctMOE),
                  ymax=(pctestimate+pctMOE)),
              alpha=.3) +
                geom_line(aes(x=year, y=pctestimate), size=1.5) +
                labs(y="Percent of commuters") +
                opts(title = expression("Percentage of commuters commuting by public transport"))

pWorkedAtHome <- ggplot(df[df$mode %in% c("Worked at home"), ]) +
  geom_ribbon(aes(x=year,
                  ymin=(pctestimate-pctMOE),
                  ymax=(pctestimate+pctMOE)),
              alpha=.3) +
                geom_line(aes(x=year, y=pctestimate), size=1.5) +
                labs(y="Percent of commuters") +
                opts(title = expression("Percentage of commuters working from home"))

pDroveAlone <- ggplot(df[df$mode %in% c("Drove alone"), ]) +
  geom_ribbon(aes(x=year,
                  ymin=(pctestimate-pctMOE),
                  ymax=(pctestimate+pctMOE)),
              alpha=.3) +
                geom_line(aes(x=year, y=pctestimate), size=1.5) +
                labs(y="Percent of commuters")

pNoDroveAlone <- ggplot(df[!df$mode %in% c("Drove alone"), ]) +
  geom_ribbon(aes(x=year,
                  ymin=(pctestimate-pctMOE),
                  ymax=(pctestimate+pctMOE),
                  group=factor(mode)),
              alpha=.3) +
                geom_line(aes(x=year, y=pctestimate, color=factor(mode)), 
                          size=1) +
                            scale_color_brewer(type="qual", palette=2) +
                            labs(y="Percent of commuters", color="Mode of Travel", group="Margin of Error")

#p2 <- ggplot(df) + geom_line(aes(year, estimate, ymin=lower, ymax=upper)) + facet_grid(mode ~ .)


# p3  <- gvisAnnotatedTimeLine(df, datevar="year",
#                                        numvar="estimate", idvar="mode",
#                                        titlevar="mode",
#                                        #annotationvar="Annotation",
#                                        options=list(displayAnnotations=FALSE,
#                                                     width=840, height=600,
#                                                     displayZoomButtons=FALSE,
#                                                     thickness=5))

pInteractive <- gvisMotionChart(df, idvar="mode", timevar="year", options=list(width=900, height=600, thickness=5, state='{"yAxisOption":"4","time":"2010","yZoomedDataMax":1.023865803,"showTrails":false,"nonSelectedAlpha":0.4,"colorOption":"_UNIQUE_COLOR","xZoomedDataMin":1136073600000,"xZoomedIn":false,"sizeOption":"_UNISIZE","xLambda":1,"uniColorForNonSelected":false,"orderedByX":false,"xAxisOption":"_TIME","yZoomedIn":false,"iconType":"LINE","duration":{"timeUnit":"D","multiplier":1},"xZoomedDataMax":1262304000000,"yZoomedDataMin":0,"iconKeySettings":[{"key":{"dim0":"Bicycled"}}],"yLambda":1,"dimensions":{"iconDimensions":["dim0"]},"playDuration":15000,"orderedByY":false};', showChartButtons=FALSE, showHeader=FALSE, showXMetricPicker=FALSE, showYMetricPicker=FALSE, showXScalePicker=FALSE, showYScalePicker=FALSE, showAdvancedPanel=TRUE))
