#-------------------------------------------------------------------------------
#
# 04_Residual_H1.R
#
# Creating Residual H1 based on Chai & Garellek (2022)
#
# M. Brinkerhoff  * UCSC  * 2024-08-16 (F)
#
#-------------------------------------------------------------------------------

### Calculating Residual h1
#### Generate the lmer model for residual h1
model.position.h1c.covariant <- lmer(h1cz ~ energyz + 
                                       (energyz||Speaker),
                                     data = slz.s,
                                     REML = FALSE)

#### extract the energy factor
energy.factor <- fixef(model.position.h1c.covariant)[2]

#### generate the residual H1 score
slz.s$H1c.resid = slz.s$h1cz - slz.s$energyz * energy.factor

write.csv(slz.s, file = "data/processed/slz_cleaned.csv", row.names = F, 
          fileEncoding = "UTF-8")

