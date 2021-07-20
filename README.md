# Ballistocardiogram

Blue whale heart beats detected in accelerometry data

## Interact
See [ballistocardiogram.html](ballistocardiogram.html).

## Data
bw180905-53_prh10_ballisto.nc is a subset of PRH variables from the bw180905-53 deployment cropped to nighttime. Run the following to generate it from the original NetCDF PRH file. You'll need to have the NCO command line tools installed.

`ncks -O -v DN,P,Aw,At -F -d At_samples,310393,652393 -F -d Aw_samples,310393,652393 -F -d DN_samples,310393,652393 -F -d P_samples,310393,652393 bw180905-53_prh10.nc bw180905-53_prh10_ballisto.nc`
