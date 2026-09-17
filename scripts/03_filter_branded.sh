#!/usr/bin/env bash
# Every object carrying brand:wikidata, as OPL.
#
# OPL rather than GeoJSON: this dataset counts objects and reads their tags,
# and never needs a geometry. Assembling multipolygons would cost time and
# would raise the question of whether a relation and its member ways are one
# feature or several, which OPL does not raise because each object is a line.
set -euo pipefail
WORK=${WORK:-/data/data/osm-jp-260831}

osmium tags-filter \
  --overwrite \
  -o "$WORK/branded.osm.pbf" \
  "$WORK/japan-260831.osm.pbf" \
  brand:wikidata

osmium cat -f opl -o "$WORK/branded.opl" --overwrite "$WORK/branded.osm.pbf"
wc -l < "$WORK/branded.opl"
