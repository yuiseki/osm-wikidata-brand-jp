#!/usr/bin/env bash
# One pass over the planet, taking a generous box around Japan. The box
# reaches into Korea, Sakhalin, the Kurils and Taiwan on purpose: the real
# border is cut afterwards with a polygon derived from this same file, so no
# boundary of another vintage is ever consulted.
set -euo pipefail
PLANET=${PLANET:-/www/html/static/openstreetmap/planet/planet-260831.osm.pbf}
WORK=${WORK:-/data/data/osm-jp-260831}
mkdir -p "$WORK"
exec osmium extract \
  --bbox 122.0,20.0,154.5,46.2 \
  --strategy complete_ways \
  --progress \
  --overwrite \
  -o "$WORK/japan-bbox-260831.osm.pbf" \
  "$PLANET"
