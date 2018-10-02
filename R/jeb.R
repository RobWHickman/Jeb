#' @title Jeb
#' @description Produce an election victory map overlaid with a picture (e.g. of Jeb! Bush)
#' @param image The image to overlay. Default to Jeb! Bush celebrating
#' @param lookup The method used to find the shapefile to use as the electoral background. Defaults to GADM
#' @param geocode The GADM code for the country shapefiles to download from GADM. Requires GADM to be the lookup method
#' @param bg_col The background fill colour for the electoral shapefiles. Defaults to a Goldenrod shape.
#' @details Generates a plot of an image over an electoral map. E.g. quickly and easily allows for Jeb! meme style maps to be generated

#' @examples
#'
#' @import ggplot2
#' @export
