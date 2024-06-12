using ASCIIrasters

## Read data
t, Ts = read_campbell(weather_fl)
dem,_ = ASCIIrasters.read_ascii(dem_fl)
mask,_ = ASCIIrasters.read_ascii(mask_fl)
Ps = Ps0 .+ Ts*0; # make precipitation a vector of same length as Ts

## Visualize input data
plot(t, Ts, xlabel="time (d)", ylabel="T (C)")
savefig(joinpath(results_dir, make_sha_filename( "breithorn_T", ".png")))
heatmap(mask)
savefig(joinpath(results_dir, make_sha_filename( "breithorn_mask", ".png")))
heatmap(dem)
savefig(joinpath(results_dir, make_sha_filename("breithorn_dem", ".png")))

## Run the model for the whole Breithorn glacier
zs = dem[mask.==1] .- z_weather_station # use elevation of weather station as datum
dt = diff(t)[1]
glacier_net_balance, net_balance = glacier_net_balance_fn(zs, dt, Ts, Ps, melt_factor, T_threshold, lapse_rate)
net_balance_map = dem.*NaN
net_balance_map[mask.==1] .= net_balance
heatmap(net_balance_map)
savefig(joinpath(results_dir, make_sha_filename("breithorn_net_balance_field", ".png")))

## Generate output table
# make a table for massbalance of different temperature offsets and store it
out = []
for dT = -4:4
    Ts_ = Ts .+ dT
    massbalance_, _ = glacier_net_balance_fn(zs, dt, Ts_, Ps, melt_factor, T_threshold, lapse_rate)
    push!(out, [dT, massbalance_])
end
writedlm(joinpath(results_dir, make_sha_filename("deltaT_impact", ".csv")), out, ',')
