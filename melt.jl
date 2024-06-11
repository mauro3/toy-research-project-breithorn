function melt(T, melt_factor)
    if T>0
        return T * melt_factor
    else
        return 0.0
    end
end
# test it
@assert melt(0, 1) == 0
@assert melt(-10, 1) == 0
@assert melt(1, 1) == 1
@assert melt(4, 7) == 4*7
@assert melt(4, 0.01) == 4*0.01


function accumulate(T, P, T_threshold)
    if T <= T_threshold
        P
    else
        return 0.0
    end
end
# test it
@assert accumulate(0, 5, 4) > 0
@assert accumulate(5, 5, 4) == 0


function lapse(T, dz, lapse_rate)
    return T + dz * lapse_rate
end
# test it
@assert lapse(5, 100, 1) > 5
@assert lapse(5, -100, 1) < 5

"""
   net_balance_fn(dt, Ts, Ps, melt_factor, T_threshold)

Integrate the balance rate (this is at a point) over time for given
temperature and precipitation arrays to get the "net balance".

# Arguments
- `dt`: The time step.
- `Ts`: Array of temperatures.
- `Ps`: Array of precipitations.
- `melt_factor`: The factor to compute melt amount.
- `T_threshold`: The temperature threshold for accumulation.

# Returns
- net balance (this is at a point)
"""
function net_balance_fn(dt, Ts, Ps, melt_factor, T_threshold)
   @assert length(Ts)==length(Ps)
   total = 0.0
   for i = 1:length(Ts)
       T, P = Ts[i], Ps[i]
       balance_rate = - melt(T, melt_factor) + accumulate(T, P, T_threshold)
       total = total + balance_rate * dt
   end
   return total
end
# try it
net_balance_fn(1/24, [5, 6], [0.1, 1], 0.005, 4)


"""
   glacier_net_balance_fn(zs, dt, Ts, Ps, melt_factor, T_threshold, lapse_rate)

Calculate:
- the glacier net balance (integration of balance rate over time and space)
- the net balance at each point (integration of balance rate over time)

# Arguments
- `zs`: Array of elevations (with the weather station as datum)
- `dt`: The time step.
- `Ts`: Array of temperatures.
- `Ps`: Array of precipitations.
- `melt_factor`: The factor to compute melt amount.
- `T_threshold`: The temperature threshold for accumulation.
- `lapse_rate`: The lapse rate (temperature change per unit elevation change).

# Returns
- the glacier net balance [m]
- net balance at all points [m]
"""
function glacier_net_balance_fn(zs, dt, Ts, Ps, melt_factor, T_threshold, lapse_rate)
   glacier_net_balance = 0.0
   net_balance = zeros(length(zs))
   for i = 1:length(zs)
       z = zs[i]
       TT = lapse.(Ts, z, lapse_rate)
       net_balance[i] = net_balance_fn(dt, TT, Ps, melt_factor, T_threshold)
       glacier_net_balance = glacier_net_balance + net_balance[i]
   end
   return glacier_net_balance/length(zs), net_balance
end
# try it
glacier_net_balance_fn(2400, 1/24, [5, 6], [0.1, 1], 0.005, 4, -0.6/100)
