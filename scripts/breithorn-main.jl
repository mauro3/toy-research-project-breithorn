## Main script to run all Breithorngletscher tasks

# Load packages
using DelimitedFiles
using Plots
using ASCIIrasters
# Load model code
include("../src/GlacierMassBalanceModel.jl")

# Keep the data-fetching separate from the processing/model code.
include("breithorn-getdata.jl")
# Keep the model parameters separate from the processing/model code, otherwise
# parameters are difficult to find.
include("breithorn-model-paras.jl")

## Load data and run the model
include("breithorn-run-model.jl")
