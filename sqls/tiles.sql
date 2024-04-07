SELECT
  ST_AsMVT (data.*, 'line') mvt
FROM
  (
    SELECT
      name,
      highway,
      ST_AsMVTGeom (way, TileBBox ({{ context.params.z }}, {{ context.params.x }}, {{ context.params.y }}), 4096, 256, true) way
    FROM
      planet_osm_line
    WHERE
      ST_Intersects (TileBBox ({{ context.params.z }}, {{ context.params.x }}, {{ context.params.y }}), way)
  ) AS data