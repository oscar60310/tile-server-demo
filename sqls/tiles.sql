WITH all_data AS (
  SELECT
    	'road' AS feature,
      name,
      highway AS category,
      way
    FROM
      planet_osm_line
    WHERE
      highway IS NOT NULL
      AND name IS NOT NULL
    
    UNION
    
    SELECT
    	'boundary' AS feature,
      name,
      NULL AS category,
      way
    FROM
      planet_osm_polygon
    WHERE
      admin_level = '4'
    
    UNION
    
    SELECT
    	'water' AS feature,
      NULL AS name,
      NULL AS category,
      way
    FROM
      water
),
tile_data AS (
 	SELECT 
  	all_data.feature,
    all_data.name,
    all_data.category,
  	ST_AsMVTGeom (all_data.way, TileBBox ({{ context.params.z }}, {{ context.params.x }}, {{ context.params.y }})) way
  FROM
  	all_data
  WHERE
  	ST_Intersects (TileBBox ({{ context.params.z }}, {{ context.params.x }}, {{ context.params.y }}), all_data.way)
)
SELECT
  ST_AsMVT (tile_data.*, tile_data.feature) mvt
FROM tile_data
GROUP BY tile_data.feature