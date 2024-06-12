include("../src/GlacierMassBalanceModel.jl")

# This is Julia's standard testing environment
using Test

# test melt
@test melt(0, 1) == 0
@test melt(-10, 1) == 0
@test melt(1, 1) == 1
@test melt(4, 7) == 4*7
@test melt(4, 0.01) == 4*0.01

# test accumulate
@test accumulate(0, 5, 4) > 0
@test accumulate(5, 5, 4) == 0

# test lapse
@test lapse(5, 100, 1) > 5
@test lapse(5, -100, 1) < 5

# integration test of simple.jl
include("../examples/simple.jl")
@test glacier_net_balance ≈ -0.11096645178976892

# utils.jl testing
@test startswith(make_sha_filename("test", ".png"), "test-")
@test endswith(make_sha_filename("test", ".png"), ".png")
