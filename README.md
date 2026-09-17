# osm-wikidata-brand-jp

Every way two independent sources name the same shop chain, across Japan, and
the name of every shop in those chains.

1,859 brands, 172,852 features, 65,026 distinct spellings across 221 name keys.

The data is on the Hugging Face Hub. This repository is how it was built.

    https://huggingface.co/datasets/yuiseki/osm-wikidata-brand-jp

The twenty-three wards of Tokyo are a separate dataset, and not a subset of a
row here: its counts are counts of the wards.

    https://huggingface.co/datasets/yuiseki/osm-wikidata-brand-tokyo23

`7-ELEVEN` on 9,698 features is a fact about Japan and `7-ELEVEN` on 1,512 is
a fact about those wards, and one file cannot say both.

## Where it comes from

A branded feature in OpenStreetMap carries `brand:wikidata`, which is a
Wikidata item id, and around it whatever names the mappers wrote. The Wikidata
item carries a label, a description and aliases in each language, written by
different people for a different purpose. Neither source reads the other, and
where they differ is the point of the file.

    OpenStreetMap   japan-260831.osm.pbf, Japan cut from the planet file of
                    2026-08-31 and read object by object with osmium
    Wikidata        wikidata-20260831-all.json.bz2, the same day

The two dates are the same day on purpose. A brand added to OpenStreetMap in
September and to Wikidata in October would otherwise look like a source
disagreeing with itself.

## How Japan was cut

From the planet file, with OpenStreetMap's own border: the administrative
relation at `admin_level=2` carrying `ISO3166-1=JP`, taken out of the same
snapshot as the data.

Natural Earth was not used and is worth a sentence, because it is the obvious
thing to reach for. Its 10m coastline runs inland of the reclaimed land around
Tokyo Bay and drops about a quarter of the special wards' area. A country
outline with that error would quietly remove the ports and the waterfronts,
which is where a great many branded features are.

Nor was a boundary of another date. A boundary drawn earlier once dropped a
way created the day before the snapshot, which broke a ward's ring, and every
area query for that ward was wrong afterwards.

Eleven places were checked against the result: Tokyo, Naha, Sapporo, Fukuoka,
Yonaguni, Minamitorishima and Chichijima are inside it; Seoul, Busan,
Vladivostok and Taipei are outside.

## A record

```json
{
  "qid": "Q259340",
  "features": 14752,
  "osm": {
    "brand": {"7-ELEVEN": 9698, "セブン-イレブン": 4930, "7-Eleven": 57},
    "brand:en": {"7-ELEVEN": 9697, "7-Eleven": 4943},
    "brand:ja": {"セブン-イレブン": 14618, "disused:セブン-イレブン": 1},
    "name": {"セブン-イレブン": 14484, "7-Eleven": 50, "セブンイレブン": 20},
    "name:en": {"7-Eleven": 14624, "Seven-Eleven": 59},
    "name:ko": {"세븐일레븐": 4576, "로손": 7}
  },
  "wikidata": {
    "label": {"en": "7-Eleven", "ja": "セブン-イレブン"},
    "description": {"en": "chain of convenience stores"},
    "aliases": {"en": ["Seven Eleven", "7-11", "711"], "ja": ["セブンイレブン"]},
    "found": true
  }
}
```

`osm` is every name key on a feature of that brand, with how many features
carry each spelling. The counts matter: a spelling on 9,698 features and a
spelling on one are both real and are not the same claim.

Three things in that record are worth seeing. `brand` holds both `7-ELEVEN`
and `セブン-イレブン`, so the same key is in two languages. `セブンイレブン`
without the hyphen is on twenty features and `セブン-イレブン` on 14,484, which
is the spelling question this file exists to answer. And `로손` is Lawson, on
seven features that say they are 7-Eleven; it is here because the file records
what is written rather than what ought to be.

The values in each key are sorted alphabetically in the file, not by count.

## What it is for

Matching a name a person types to a thing on a map. `7-ELEVEN`, `7-Eleven`,
`Seven Eleven`, `7-11`, `711`, `セブン-イレブン`, `セブンイレブン` and
`Sebun Irebun` are one shop, and no single source has all eight.

The Japanese side is where the two sources are furthest apart. Romaji are
OpenStreetMap's alone, and they disagree with each other about long vowels:
Starbucks is `Sutah-bakkusu` on 218 features and `Sutābakkusu` on 173.
Abbreviations are in both but thinly on the map, and `docs/` says how thinly.

## Read this first

`docs/what-is-in-here-and-what-is-wrong-with-it.md`. A name key is not a brand
key, some chains have two Wikidata items, 621 of the 1,859 brands appear on a
single feature, and twelve point at Wikidata items that no longer exist.
Nothing is filtered out over any of it; the keys and the counts are in the
record so that a reader can filter for themselves.

## Building it

Two inputs have to be in place first.

The planet file of 2026-08-31, 89 GiB, md5 c67437924cf55de40e8708c7192f354d,
from `https://planet.openstreetmap.org/pbf/planet-260831.osm.pbf`. OSM keeps
its dated planet files for about ten years, which is what makes this chain
checkable years from now.

The Wikidata dump, 96 GiB, from
`https://dumps.wikimedia.org/wikidatawiki/entities/20260831/`. Do not
decompress it: 96 GiB compressed is well over a terabyte open. `lbzip2` reads
it across all cores and `bzip2` takes hours on one.

Then, in order:

```sh
scripts/00_extract_bbox.sh          # one pass over the planet, about 85 min
scripts/01_build_japan_boundary.py  # the border, from that same file
scripts/02_clip_japan.sh            # the box down to the country
scripts/03_filter_branded.sh        # the objects carrying brand:wikidata
scripts/04_wikidata.sh              # the ids, the dump pass, the join
```

The dump pass reads 121,519,241 items in about 49 minutes and keeps 105,246:
the 101,873 that the extract points at through any `*:wikidata` key, plus the
ones carrying property `P1282`. It decides on bytes before parsing, because
fewer than one item in a thousand is wanted.

Checksums, so that a rebuild can be told from a coincidence:

    planet-260831.osm.pbf   md5 c67437924cf55de40e8708c7192f354d
    japan-260831.osm.pbf    md5 2f803a54de5bdeb5ecbbb740c9b5100d
                            318,225,406 nodes, 45,679,976 ways,
                            241,943 relations
    wikidata-20260831-all.json.bz2
                            md5  f99e3ee0778ffe1c3b54fa5dbc6ce395
                            sha1 b24eea0dee9f2fbe7ca70e6efe3209eb69bc48af

## Two licences in one file

This joins an ODbL source to a CC0 one, so which field came from where is
part of the data rather than a footnote. `data/provenance.yaml` says it field
by field, and the record says it structurally: everything under `osm` is from
OpenStreetMap and everything under `wikidata` is from Wikidata.

    OpenStreetMap   japan-260831.osm.pbf, ODbL-1.0
                    qid, features, and every spelling under `osm`
    Wikidata        wikidata-20260831-all.json.bz2, CC0-1.0
                    label, description and aliases under `wikidata`

Wikidata's CC0 covers structured data in the main, property and lexeme
namespaces; text elsewhere on the site is CC BY-SA 4.0. Everything taken here
is main-namespace structured data. Wikidata asks for no attribution.

The file contains content derived from OpenStreetMap, so redistributing it
means complying with ODbL. That is two obligations and not one: credit
OpenStreetMap, and make clear the data is under ODbL.

    (c) OpenStreetMap contributors, available under the Open Database License.
    https://www.openstreetmap.org/copyright

The CC0 half carries no conditions of its own, and sitting beside ODbL content
does not give it any. Nor does the reverse.

Whether joining the two on a shared key makes a Derivative Database or a
Collective Database under ODbL section 4.5 is not settled here. They are
joined into one record rather than shipped in one archive, which is why the
stricter reading is the one taken. That is a position and not legal advice,
and it was reached without reading the ODbL legal text.

The code in `src/` and `scripts/` is MIT.
