create view explore.penguins_unc 
( id, island, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, sex, year )
as select 
id, island, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, sex, year
from explore.penguins ;

SELECT * FROM                                        
    (SELECT C.*, AI_SIMILARITY(CUSTOMERID, '3668-QPYBK') AS SIMILARITY                  
     FROM DSNAIDB.CHURN C                               
     WHERE CUSTOMERID <> '3668-QPYBK')                  
   WHERE SIMILARITY > 0.5                               
   ORDER BY SIMILARITY DESC                             
   FETCH FIRST 20 ROWS ONLY;