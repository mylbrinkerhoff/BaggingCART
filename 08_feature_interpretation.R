#-------------------------------------------------------------------------------
#
# 08_feature_interpretation.R
#
# Generating a Bagging decission tree
#
# M. Brinkerhoff  * UCSC  * 2024-08-16 (F)
#
#-------------------------------------------------------------------------------

# make bootstrapping reproducible
vip::vip(slz_bag2, num_features = 22, geom = "point", all_permutations = T)

