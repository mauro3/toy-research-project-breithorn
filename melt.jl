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
