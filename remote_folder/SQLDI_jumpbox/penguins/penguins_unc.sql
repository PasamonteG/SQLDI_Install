create view explore.penguins_unc 
( id, island, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, sex, year )
as select 
id, island, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, sex, year
from explore.penguins ;