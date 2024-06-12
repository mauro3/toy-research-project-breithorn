include("../src/GlacierMassBalanceModel.jl")

# test melt
@assert melt(0, 1) == 0
@assert melt(-10, 1) == 0
@assert melt(1, 1) == 1
@assert melt(4, 7) == 4*7
@assert melt(4, 0.01) == 4*0.01

# test accumulate
@assert accumulate(0, 5, 4) > 0
@assert accumulate(5, 5, 4) == 0

# test lapse
@assert lapse(5, 100, 1) > 5
@assert lapse(5, -100, 1) < 5

# integration test of simple.jl
include("../examples/simple.jl")
@assert glacier_net_balance ≈ -0.11096645178976892
