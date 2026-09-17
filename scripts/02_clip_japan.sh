#!/usr/bin/env bash
# Cut the box down to the country, with the outline derived in step 1.
#
# complete_ways, so a way that crosses the outline keeps all of its nodes.
# The alternative, filtering the branded features first and clipping the small
# file afterwards, cannot be done: a way carries no coordinates of its own, so
# deciding whether it is in Japan needs the nodes that the filter would drop.
set -euo pipefail
WORK=${WORK:-/data/data/osm-jp-260831}
POLY="$(dirname "$0")/../data/japan_osm_boundary.geojson"

test -r "$WORK/japan-bbox-260831.osm.pbf"
test -r "$POLY"

osmium extract \
  --polygon "$POLY" \
  --strategy complete_ways \
  --progress \
  --overwrite \
  -o "$WORK/japan-260831.osm.pbf" \
  "$WORK/japan-bbox-260831.osm.pbf"

md5sum "$WORK/japan-260831.osm.pbf" > "$WORK/japan-260831.osm.pbf.md5"
osmium fileinfo -e "$WORK/japan-260831.osm.pbf" | tee "$WORK/japan-260831.fileinfo.txt"
