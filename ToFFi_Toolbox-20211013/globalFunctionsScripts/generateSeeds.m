function seedVec = generateSeeds(n)
%%
% Generates n seed values using current random number generator and returns
% them as an array.

MAX_SEED = 2^32-1;
seedVec = randi(MAX_SEED, 1, n);
