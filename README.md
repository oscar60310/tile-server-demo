## Initialization

1. Clone this project
  ```bash
  git clone xxx
  ```


1. Initialize a PostGis instance.
  ```bash
  docker compose up -d
  ```


1. Download source data of Taiwan. (license: https://www.openstreetmap.org/copyright)
  ```bash
  ./script/01_prepare_osm_data.sh
  ```

1. Install dependencies.
  ```bash
  npm i
  ```

1. Start server
  ```bash
  npm start
  ```

## Access tiles
localhost:3000/api/tiles/{z}/{x}/{y}.mvt


