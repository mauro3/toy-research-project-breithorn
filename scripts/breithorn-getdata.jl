# Load packages
using Plots
# Load model code
include("../src/GlacierMassBalanceModel.jl")

# This script prepares data for Breithorngletscher near Zermatt, Switzerland
results_dir = joinpath(@__DIR__, "../../results") # will be used later for storing outputs

## Setup project folder
mkpath(joinpath(@__DIR__, "../../data/own"))      # this is where our data is placed
mkpath(joinpath(@__DIR__, "../../data/foreign"))  # this is where other peoples data is placed
mkpath(results_dir)       # this is where results go

## Download data
# weather
weather_fl = joinpath(@__DIR__, "../../data/own/weather.dat")
download_file("https://raw.githubusercontent.com/mauro3/CORDS/master/data/workshop-reproducible-research/own/weather.dat", weather_fl)
# glacier mask
mask_zip = joinpath(@__DIR__, "../../data/own/mask_breithorngletscher.zip")
mask_fl = joinpath(@__DIR__, "../../data/own/mask_breithorngletscher.asc")
download_file("https://github.com/mauro3/CORDS/raw/master/data/workshop-reproducible-research/own/mask_breithorngletscher.zip", mask_zip)
unzip_one_file(mask_zip, "mask_breithorngletscher/mask_breithorngletscher.asc", mask_fl)
# digital elevation model (DEM)
dem_zip = joinpath(@__DIR__, "../../data/foreign/swisstopo_dhm200_cropped.zip")
dem_fl = joinpath(@__DIR__, "../../data/foreign/dhm200_cropped.asc")
download_file("https://github.com/mauro3/CORDS/raw/master/data/workshop-reproducible-research/foreign/swisstopo_dhm200_cropped.zip", dem_zip)
unzip_one_file(dem_zip, "swisstopo_dhm200_cropped/dhm200_cropped.asc", dem_fl)


## Some extra data, manually entered
z_weather_station = 2650 # elevation of weather station [m]
Ps0 = 0.005 # mean (and constant) precipitation rate [m/d]
