function closeParpool
%%
% Erase opened parallel pool.
%%

delete(gcp('nocreate')) % erasing previous parallel pool
