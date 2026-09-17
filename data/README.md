---
license: odbl
language:
- en
- ja
task_categories:
- text-classification
- sentence-similarity
tags:
- openstreetmap
- wikidata
- entity-linking
- name-matching
- brands
- japan
- japanese
size_categories:
- 1K<n<10K
---

# osm-wikidata-brand-jp

Every way two independent sources name the same shop chain, across Japan, and
the name of every shop in those chains.

1,859 brands, 172,852 features, 65,026 distinct values across 221 keys.

The twenty-three wards of Tokyo are a separate dataset,
`osm-wikidata-brand-tokyo23`. Its counts are counts of the wards, and a count
of Japan cannot stand in for one: `7-ELEVEN` is on 9,698 features here and on
1,512 there.

A branded feature in OpenStreetMap carries `brand:wikidata`, which is a
Wikidata item id, and around it whatever names the mappers wrote. The Wikidata
item carries a label, a description and aliases in each language, written by
different people for a different purpose. Neither source reads the other, and
where they differ is the point of the file.

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

Three things in that record are the reason for the file. `brand` holds both
`7-ELEVEN` and `セブン-イレブン`, so one key is in two languages. `セブンイレブン`
without the hyphen is on twenty features and `セブン-イレブン` on 14,484. And
`로손` is Lawson, on seven features that say they are 7-Eleven.

Values are sorted alphabetically in the file, not by count.

## The keys

    name             1839 brands
    brand            1469 brands
    name:en          1151 brands
    name:ja          1102 brands
    brand:en          849 brands
    brand:ja          837 brands
    name:ja-Hira      440 brands
    name:ja-Latn      419 brands
    name:ja_rm        411 brands
    official_name     156 brands

`name` and `brand` are not the same thing and the difference is useful rather
than noise. `brand:ja` is what the chain is called; `name` on a single shop is
often that plus the branch, `マクドナルド 上野店`. So `brand*` gives the
variants of one concept, and `name*` gives real instances of it, which is what
a matcher has to cope with in practice.

## Read this before using it

Some things look like defects and are not.

A shared car park or a bicycle port standing in a convenience store's lot can
carry the scheme's `brand:wikidata` beside the shop's `name`, so a few brands
appear to be called something they are not. Some chains have two Wikidata
items and both are here, because merging them would answer a question Wikidata
itself has two entries for.

    621 of the 1,859 brands appear on exactly one feature
    725 appear on ten or more
    12 point at Wikidata items that are not in the dump, and carry
       "found": false with an empty label

Two more brands carry `brand:wikidata` on a feature with no name key at all.
They have no spelling, so they are not in the file; the build prints how many.

Nothing is filtered out over any of it. The keys and the counts are in the
record so that a reader can filter for themselves.

## Where it comes from

    OpenStreetMap   japan-260831.osm.pbf, Japan cut from the planet file of
                    2026-08-31 with OpenStreetMap's own border and read
                    object by object with osmium
                    md5 2f803a54de5bdeb5ecbbb740c9b5100d
    Wikidata        wikidata-20260831-all.json.bz2, the same day
                    md5 f99e3ee0778ffe1c3b54fa5dbc6ce395

The same day on purpose: a brand added to one in September and the other in
October would look like the sources disagreeing when the only difference is
when each was read. Both checksums are the ones the sources publish.

Japan was cut with the administrative relation at `admin_level=2` carrying
`ISO3166-1=JP`, taken out of the same snapshot as the data. Not Natural Earth,
whose 10m coastline runs inland of the reclaimed land around Tokyo Bay and
would quietly remove the waterfronts, and not a boundary of another date.

`provenance.yaml` beside this file has the commands, the versions and the item
counts, field by field.

## Two licences meet here

    OpenStreetMap   ODbL-1.0    `qid`, `features`, everything under `osm`
    Wikidata        CC0-1.0     everything under `wikidata`

Redistributing this means complying with ODbL, which asks two things: credit
OpenStreetMap, and make clear the data is under ODbL.

    (c) OpenStreetMap contributors, available under the Open Database License.
    https://www.openstreetmap.org/copyright

Wikidata's CC0 covers structured data in the main, property and lexeme
namespaces; text elsewhere on the site is CC BY-SA 4.0. Everything taken here
is main-namespace structured data, and Wikidata asks for no attribution.
