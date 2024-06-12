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
@test startswith(make_sha_filename("test", ".png"), "$(string(now())[1:end-7])-test-")
@test endswith(make_sha_filename("test", ".png"), ".png")

function expensive_computation(x, y)
    #sleep(5)  # Simulates a long-running computation
    return x + y
end

# Cache file base name
mkpath("cache")

# Run the function and cache its result
rm("cache/expensive_computation_result.jlso", force=true)
result = run_cache(expensive_computation, (3,4), "cache/expensive_computation_result")
@test result == expensive_computation(3,4)
# now with result cached
result = run_cache(expensive_computation, (3,4), "cache/expensive_computation_result")
@test result == expensive_computation(3,4)
result = run_cache(expensive_computation, (5, 5), "cache/expensive_computation_result")
@test result != expensive_computation(5, 5) # caching does not take args into account

# campbell file reader
@test parse_campbell_date_time(2007, 1, 1239) ≈ 0.5270833333333333
@test parse_campbell_date_time(2007, 365, 2359) ≈ 364.9993055555555
