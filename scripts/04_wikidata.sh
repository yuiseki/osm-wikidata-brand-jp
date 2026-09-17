#!/bin/bash
# The ids, then the one pass over the dump. Both steps log to tmp.
set -euo pipefail
cd "$(dirname "$0")/.."
python3 src/qids.py --out tmp/qids.txt
python3 src/wikidata_osm_tags.py \
  --dump /data/www/html/static/wikimedia/wikidata/wikidata-20260831-all.json.bz2 \
  --qids tmp/qids.txt --out tmp/wikidata.jsonl --jobs 12
python3 src/build.py --out data/brands.jsonl
