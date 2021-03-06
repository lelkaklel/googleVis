### File R/gvisGeoMap.R
### Part of the R package googleVis
### Copyright 2010, 2011, 2012, 2013 Markus Gesmann, Diego de Castillo

### It is made available under the terms of the GNU General Public
### License, version 2, or at your option, any later version,
### incorporated herein by reference.
###
### This program is distributed in the hope that it will be
### useful, but WITHOUT ANY WARRANTY; without even the implied
### warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
### PURPOSE.  See the GNU General Public License for more
### details.
###
### You should have received a copy of the GNU General Public
### License along with this program; if not, write to the Free
### Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
### MA 02110-1301, USA

#'

#' Google Geo Map with R 
#' \Sexpr{googleChartName <- "geomap"}
#' \Sexpr{gvisChartName <- "gvisGeoMap"}
#' @description
#' The gvisGeoMap function reads a data.frame and
#' creates text output referring to the Google Visualisation API, which can be
#' included into a web page, or as a stand-alone page.
#' 
#' A geo map is a map of a country, continent, or region map, with colours
#' and values assigned to specific regions. Values are displayed as a colour
#' scale, and you can specify optional hover-text for regions. The map is
#' rendered in the browser. Note that the
#' map is not scroll-able or drag-gable, but can be configured to allow
#' zooming.
#'
#' @param data \code{data.frame}. The data has to have at least two
#' columns with location name (\code{locationvar}), value to be mapped
#' to location (\code{numvar}) and an optional variable to display any
#' text while the mouse hovers over the location (\code{hovervar}).
#' @param locationvar column name of \code{data} with the geo locations to be
#' analysed. The locations can be provide in two formats:
#' 
#' \describe{      
#' \item{Format 1}{'latitude:longitude'. See the example below.}
#' \item{Format 2}{Address, country name, region name locations, or
#' US metropolitan area codes, see
#' \url{http://code.google.com/apis/adwords/docs/developer/adwords_api_us_metros.html}. 
#' This format works with the \code{dataMode} option set to either
#' 'markers' or 'regions'. The following formats are accepted: 
#' A specific address (for example, "1600 Pennsylvania Ave"). 
#' A country name as a string (for example, "England"), or an uppercase ISO-3166 code
#'  or its English text equivalent (for example, "GB" or "United Kingdom").
#'   An uppercase ISO-3166-2 region code name or its English text
#'    equivalent (for example, "US-NJ" or "New Jersey"). 
#'    }
#'  }
#' @param numvar column name of \code{data} with the numeric value
#'   displayed when the user hovers over this region.
#' @param hovervar column name of \code{data} with the additional string
#'  text displayed when the user hovers over this region. 
#' @param options list of configuration options.
#' The options are documented in detail by Google online:
#' 
#' % START DYNAMIC CONTENT
#' 
#' \Sexpr[results=rd]{gsub("CHARTNAME", 
#' googleChartName,
#' readLines(file.path(".", "inst",  "mansections", 
#' "GoogleChartToolsURLConfigOptions.txt")))}
#' 
#'  \Sexpr[results=rd]{paste(readLines(file.path(".", "inst", 
#'  "mansections", "gvisOptions.txt")))}
#'   
#' @param chartid character. If missing (default) a random chart id will be 
#' generated based on chart type and \code{\link{tempfile}}
#' 
#' @return \Sexpr[results=rd]{paste(gvisChartName)} returns list 
#' of \code{\link{class}}
#'  \Sexpr[results=rd]{paste(readLines(file.path(".", "inst", 
#'  "mansections", "gvisOutputStructure.txt")))}
#'   
#' @references Google Chart Tools API: 
#' \Sexpr[results=rd]{gsub("CHARTNAME", 
#' googleChartName, 
#' readLines(file.path(".", "inst",  "mansections", 
#' "GoogleChartToolsURL.txt")))}
#' 
#' % END DYNAMIC CONTENT
#' 
#' @author Markus Gesmann \email{markus.gesmann@@gmail.com}, 
#' Diego de Castillo \email{decastillo@@gmail.com}
#' 
#' 
#' @section Warnings:
#' Because of Flash security settings the chart 
#' might not work correctly when accessed from a file location in the 
#' browser (e.g., file:///c:/webhost/myhost/myviz.html) rather than 
#' from a web server URL (e.g. http://www.myhost.com/myviz.html). 
#' See the googleVis package vignette and the Macromedia web 
#' site (\url{http://www.macromedia.com/support/documentation/en/flashplayer/help/}) 
#' for more details.
#' 
#' @export
#'  
#' @keywords iplot
#' 
#' @examples
#' ## Please note that by default the googleVis plot command
#' ## will open a browser window and requires Internet
#' ## connection to display the visualisation.
#' 
#' ## Regions Example
#' ## The regions style fills entire regions (typically countries) with colors
#' ## corresponding to the values that you assign. Specify the regions style
#' ## by assigning options['dataMode'] = 'regions' in your code.
#' 
#' G1 <- gvisGeoMap(Exports, locationvar='Country', numvar='Profit',
#'                  options=list(dataMode="regions")) 
#' 
#' plot(G1)
#' 
#' ## Markers Example
#' ## The "markers" style displays a circle, sized and colored to indicate
#' ## a value, over the regions that you specify. 
#' G2 <- gvisGeoMap(CityPopularity, locationvar='City', numvar='Popularity',
#'                  options=list(region='US', height=350, 
#'                               dataMode='markers',
#'                               colors='[0xFF8747, 0xFFB581, 0xc06000]'))  
#' 
#' plot(G2) 
#' 
#' ## Example showing US data by state 
#' 
#' require(datasets)
#' states <- data.frame(state.name, state.x77)
#' 
#' G3 <- gvisGeoMap(states, "state.name", "Illiteracy",
#'                  options=list(region="US", dataMode="regions",
#'                               width=600, height=400))
#' plot(G3) 
#' 
#' ## Example with latitude and longitude information
#' ## Show Hurricane Andrew (1992) storm track
#' G4 <- gvisGeoMap(Andrew, locationvar="LatLong", numvar="Speed_kt", 
#'                  hovervar="Category", 
#'                  options=list(height=350, region="US", dataMode="markers"))
#' 
#' plot(G4) 
#' 
#' ## World population
#' WorldPopulation=data.frame(Country=Population$Country, 
#'                            Population.in.millions=round(Population$Population/1e6,0),
#'                            Rank=paste(Population$Country, "Rank:", Population$Rank))
#' 
#' G5 <- gvisGeoMap(WorldPopulation, "Country", "Population.in.millions", "Rank", 
#'                  options=list(dataMode="regions", width=600, height=300))
#' plot(G5)
#' 

gvisGeoMap <- function(data, locationvar="", numvar="", hovervar="", options=list(), chartid){

  my.type <- "GeoMap"
  dataName <- deparse(substitute(data))

  my.options <- list(gvis=modifyList(list(width = 556, height=347),options), 
                     dataName=dataName,
                     data=list(locationvar=locationvar, numvar=numvar,
                       hovervar=hovervar,  
                     allowed=c("number", "string")))
  
  checked.data <- gvisCheckGeoMapData(data, my.options)

  if(any("numeric" %in% lapply(checked.data[,c(1,2)],class))){
    my.options <- modifyList(list(gvis=list(dataMode = "regions")), my.options)
  }
  output <- gvisChart(type=my.type, checked.data=checked.data, options=my.options, chartid=chartid)
  
  return(output)
}

gvisCheckGeoMapData <- function(data, options){

  data.structure <- list(
        	     locationvar = list(mode="required",FUN=check.location),
        	     numvar      = list(mode="optional",FUN=check.num),
        	     hovervar    = list(mode="optional",FUN=check.char))
	
  x <- gvisCheckData(data=data,options=options,data.structure=data.structure)

  if (sum(nchar(gsub("[[:digit:].-]+:[[:digit:].-]+", "", x[[1]]))) == 0){
  	# split first index and delete this one
  	latlong <- as.data.frame(do.call("rbind",strsplit(as.character(x[[1]]),':')))
  	x[[1]] <- NULL
	varNames <- names(x)
  	x$Latitude <- as.numeric(as.character(latlong$V1))
  	x$Longitude <- as.numeric(as.character(latlong$V2))
    	x <- x[c("Latitude","Longitude",varNames)]
  }

  return(data.frame(x))
}

