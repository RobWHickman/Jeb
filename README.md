
# Jeb! <img src = "man/figure/HexSticker.png" align = "right" width = "200"/>

##Jeb wins meme plots in R

This package is a small thing I threw together last summer to create plots of the [Jeb wins meme](https://knowyourmeme.com/memes/jeb-wins). The package is pretty self-explanatory. Just playing arouynd with it should be easiest.

n.b. this package downloads shapefiles from GADM as a default so be careful of data usage/ slow processing of files that can be quite large

To install this package

```{r}
devtools::install_github("robwhickman/Jeb")
```

##Use

The sole function ```jeb()``` produces a ggplot2 object of a map with a raster annotation over it. To produce the map it uses the [simple features package](https://github.com/r-spatial/sf) and ```geom_sf()``` from the recent ggplot2 package.

To get the shapefiles for this map, it by default searches GADM (using a defined country iso3c code and level number). If a fuller name is given for the country, it will attempt to find the iso3c code using the ```countrycode()``` function from the package of the same name. For levels, 0 is the country as a whole and generally you won't want/be able to go higher than 2.

To install the package use

```{r}
devtools::install_github("robwhickman/Jeb")
```

then we can use it to create a meme using (e.g.)

```{r}
jeb_meme <- jeb(country = "France", level = 2)

plot(jeb_meme)
```

n.b. the USA shapefile on GADM is both large and contains islands which stretch past the date line so doesn't actually work that well with the GADM setting.

If you want to use your own overlay picture or shapefiles you can do. The image argument can take a path to a .png file to read and plot as a raster. By setting lookup to anything other than "GADM", the function will look in the environment for anything object specified in the country argument. It will then attempt to coerce this to an sf object and plot it.
