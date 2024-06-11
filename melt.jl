function melt(T, melt_factor)
    if T>0
        return T * melt_factor
    else
        return 0.0
    end
end
# try it out
melt(1, 0.5)


function accumulate(T, P, T_threshold)
    if T <= T_threshold
        P
    else
        return 0.0
    end
end
# try it out
accumulate(0, 5, 0.5)
accumulate(5, 5, 7)


function lapse(T, dz, lapse_rate)
    return T + dz * lapse_rate
end
# try it out
lapse(5, 100, 1)
lapse(5, -100, 1)
