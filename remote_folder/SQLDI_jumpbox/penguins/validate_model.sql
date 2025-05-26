-- Average Similarity Between Penguin # 11 and all other Adelie Penguins

with V1 as ( 
SELECT U.*, decimal(AI_SIMILARITY(ID,11),5,2) AS SIMILARITY       
     FROM EXPLORE.PENGUINS_UNC U 
     WHERE U.ID between 1 and 152 )
select AVG(similarity) from V1 ;

-- Average Similarity Between Penguin # 11 and all Gentoo Penguins

with V1 as ( 
SELECT U.*, decimal(AI_SIMILARITY(ID,11),5,2) AS SIMILARITY       
     FROM EXPLORE.PENGUINS_UNC U 
     WHERE U.ID between 153 and 276 )
select AVG(similarity) from V1 ;

-- Average Similarity Between Penguin # 11 and all Chinstrap Penguins

with V1 as ( 
SELECT U.*, decimal(AI_SIMILARITY(ID,11),5,2) AS SIMILARITY       
     FROM EXPLORE.PENGUINS_UNC U 
     WHERE U.ID between 277 and 344 )
select AVG(similarity) from V1 ;