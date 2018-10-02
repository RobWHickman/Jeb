#' @title Jeb
#' @description Produce an election victory map overlaid with a picture (e.g. of Jeb! Bush)
#' @param image The image to overlay. Default to Jeb! Bush celebrating, otherwise, a file path to (preferably) a .png file
#' @param lookup The method used to find the shapefile to use as the electoral background. Defaults to GADM
#' @param shape_code The GADM code for the country shapefiles to download from GADM. Requires GADM to be the lookup method
#' @param geocode The GADM level for the country shapefiles to download from GADM. Requires GADM to be the lookup method
#' @param bg_col The background fill colour for the electoral shapefiles. Defaults to a Goldenrod shape.
#' @details Generates a plot of an image over an electoral map. E.g. quickly and easily allows for Jeb! meme style maps to be generated

#' @examples
#'
#' @import ggplot2
#' @importFrom rmapshaper ms_simplify
#' @importFrom ggthemes theme_map
#' @export
jeb <- function(image = "default",
                lookup = "GADM",
                shape_code = "USA",
                level = 1,
                bg_col = "goldenrod",
                name = NULL) {

  #get the electoral shape files
  if(lookup == "GADM") {
    admin_url <- paste0("https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_", paste0(shape_code, "_", level, "_sf.rds"))
    temp_dir <- tempdir()
    download.file(admin_url, destfile = file.path(temp_dir, "shapefiles.rds"), mode = "wb")

    admin_shape <- readRDS(file.path(temp_dir, "shapefiles.rds"))

    name <- unique(admin_shape$NAME_0)
  } else {
    message("searching environment for shape_code")

    name = name
  }

  simple_admin <- ms_simplify(admin_shape)
  admin_bbox <- st_bbox(simple_admin) * c(0.995, 0.995, 1.005, 1.005)

  simple_admin$fill <- "Jeb!"

  #get the overlay image
  if(image == "default") {
    overlay <- image_read("./man/figure/JEB.png")
  } else {
    message("finding overlay image")
    overlay <- image_read(image)
  }

  #plot the electoral map
  map <- ggplot() +
    geom_sf(data = simple_admin, aes(fill = fill)) +
    scale_fill_manual(values = bg_col, name = NULL) +
    ggtitle(paste(name, "Election Results")) +
    ggthemes::theme_map() +
    theme(plot.title = element_text(size=50)) +
    theme(legend.position = "right",
          legend.text = element_text(size = 15)) +
    guides(fill = guide_legend(override.aes = list(size = 15))) +
    annotation_raster(as.raster(overlay), admin_bbox[1], admin_bbox[3], admin_bbox[2], admin_bbox[4])

  return(map)
}

