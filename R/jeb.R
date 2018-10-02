#' @title Jeb
#' @description Produce an election victory map overlaid with a picture (e.g. of Jeb! Bush)
#' @param image The image to overlay. Default to Jeb! Bush celebrating, otherwise, a file path to (preferably) a .png file
#' @param lookup The method used to find the shapefile to use as the electoral background. Defaults to GADM
#' @param country The GADM code for the country shapefiles to download from GADM. If not using GADM, searches the environment for a matching object
#' @param level The GADM level for the country shapefiles to download from GADM. Requires GADM to be the lookup method
#' @param bg_col The background fill colour for the electoral shapefiles. Defaults to a Goldenrod shape.
#' @param name The name for the country on the final plot title. If using GADM, will find this from the NAME_0 column of the downloaded shape
#' @details Generates a plot of an image over an electoral map. E.g. quickly and easily allows for Jeb! meme style maps to be generated

#' @examples
#'
#' @import ggplot2
#' @importFrom rmapshaper ms_simplify
#' @importFrom ggthemes theme_map
#' @importFrom png readPNG
#' @importFrom countrycode countrycode
#' @export
jeb <- function(image = "default",
                lookup = "GADM",
                country = "USA",
                level = 1,
                bg_col = "goldenrod",
                name = NULL) {

  #if a full country name is given, attempt to find iso3c code
  if(nchar(country) > 3) {
    message("attempting to find matching country iso3c code")
    country <- countrycode(country, 'country.name', 'iso3c')
  }

  #get the electoral shape files
  if(lookup == "GADM") {
    #download a matching country shapefile from GADM and open it
    admin_url <- paste0("https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_", paste0(country, "_", level, "_sf.rds"))
    temp_dir <- tempdir()
    download.file(admin_url, destfile = file.path(temp_dir, "shapefiles.rds"), mode = "wb")

    admin_shape <- readRDS(file.path(temp_dir, "shapefiles.rds"))

    #get the full name of the country from the NAME_0 column of the sf data.frame
    name <- unique(admin_shape$NAME_0)

    #otherwise search the environment for a matching object to use as a shapefile
    } else {
      message("searching environment for country")
      admin_shape <- country

      #if matching object is not an sf object, try to coerce
      if(all(class(admin_shape) != "sf")) {
        message("coercing object to sf")
        admin_shape <- st_as_sf(admin_shape)
      }

      #use a supplied name if wanted for the final plot
      name = name
  }

  #GADM shapefiles can be large
  #if size is larger than ~10mb try to simplify it with rmapshaper's ms_simplify
  if(object.size(admin_shape) > 10000000) {
    warning("large object size of map- attempting to simplify!")
    admin_shape <- ms_simplify(admin_shape)
  }

  #get the bounding box of the admin shapefile
  admin_bbox <- st_bbox(admin_shape) * c(0.995, 0.995, 1.005, 1.005)
  #set the fill column
  admin_shape$fill <- "Jeb!"

  #get the overlay image
  if(image == "default") {
    overlay <- readPNG("./man/figure/JEB.png")
  } else {
    #search a defined path for an image to overlay
    message("finding overlay image")
    overlay <- readPNG(image)
  }

  #plot the electoral map
  map <- ggplot() +
    geom_sf(data = admin_shape, aes(fill = fill)) +
    scale_fill_manual(values = bg_col, name = NULL) +
    ggtitle(paste(name, "Election Results")) +
    ggthemes::theme_map() +
    theme(plot.title = element_text(size=50)) +
    theme(legend.position = "right",
          legend.text = element_text(size = 15)) +
    guides(fill = guide_legend(override.aes = list(size = 15))) +
    #add the image as a raster
    annotation_raster(as.raster(overlay), admin_bbox[1], admin_bbox[3], admin_bbox[2], admin_bbox[4])

  return(map)
}

