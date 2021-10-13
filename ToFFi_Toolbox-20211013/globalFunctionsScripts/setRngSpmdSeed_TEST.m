clear; clc

if 0
    spmd(2)
	setRngSpmdSeed(10, labindex, 2)
	R = rng
	R.State
    end
end


if 1
    spmd(2)
	setRngSpmdSeed('time', labindex, 2)
	R = rng
	R.State
    end
end
