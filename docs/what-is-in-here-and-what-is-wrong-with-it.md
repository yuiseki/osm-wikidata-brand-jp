# What is in here, and what is wrong with it

Everything below is in the file. Nothing is filtered out over any of it,
because a reader who wants to filter needs to see what they are filtering.

## One chain, two Wikidata items

Twelve English labels are carried by more than one item, and the split is not
always small:

    FamilyMart   Q11247682 on 5,621 features,  Q1191685 on 5,401
    Shell        Q110716465 on 261,            Q154950 on 39
    Denny's      Q11320661 on 278,             Q1189695 on 3

FamilyMart is the one to know about. Anyone joining on `qid` and expecting one
row per chain will get half the shops. Both ids are here with the features
that carry them, because merging them would be asserting an answer to a
question Wikidata itself has two entries for.

## The name on a feature is not always the brand's name

48 brands have a commonest `name` that matches none of their brand spellings.
Some of those are the interesting part of the file rather than errors:

    Q584601    brand:en Baskin-Robbins    name サーティワンアイスクリーム on 335
    Q1054787   brand:en Nippon Telegraph and Telephone    name NTT on 357

Baskin-Robbins trades in Japan as サーティワン, thirty-one, and no source that
holds only the English name will ever match what is written on the map. That
is the whole reason for keeping `name` beside `brand`.

Others are mistagging. A shared car park or a bicycle port standing in a
convenience store's lot can carry the scheme's `brand:wikidata` beside the
shop's own `name`, and then a bicycle scheme appears to be called 7-Eleven.

## Things written in the wrong language

`name:ko` on 7-Eleven holds `로손`, which is Lawson, on seven features.
`brand:ja` holds `disused:セブン-イレブン` once, where a lifecycle prefix was
put on the value instead of the key. These are in the file because it records
what is written, and a name matcher meets exactly this.

## Most brands are barely there

    621 of the 1,859 appear on exactly one feature
    725 appear on ten or more

A brand on one feature contributes one spelling and no evidence about which
spelling is usual. The `features` field is on every record so that a reader
can require whatever support they need.

## Twelve items are not in Wikidata

Twelve records carry `"found": false` with an empty label, description and
aliases. An id in OpenStreetMap is what a mapper typed, and Wikidata deletes
and merges items without telling anyone who linked to one.

## Two brands are not here at all

Two features carry `brand:wikidata` and no name key of any kind. They have no
spelling, so they have nothing to say in a file about spellings. The build
prints how many rather than dropping them silently.

## What the extent does and does not include

Japan is cut with OpenStreetMap's own `admin_level=2` relation for JP, which
follows the coast and the maritime borders. It is a superset of the land, and
it is used only to decide what is in the country.

Where OpenStreetMap draws that border is OpenStreetMap's business and not this
file's: the northern and the western ends of it are disputed between states,
and this dataset reports what the relation contained on 2026-08-31 rather than
taking a position.

## What the two sources each know that the other does not

This is the reason the file exists rather than a caveat.

OpenStreetMap has the romaji, and disagrees with itself about long vowels.
Starbucks, on 1,323 features, is written four ways in `name:ja_rm`:

    Sutah-bakkusu  218
    Sutābakkusu    173
    Sutbakkusu       2
    Sutaabakkusu     1

Three of those are attempts at the same long vowel and the fourth is a typo.
No Wikidata alias has any of them.

Abbreviations are in both, thinly. `スタバ` is a Wikidata alias for Starbucks
and is also on the map, under `short_name` and `short_name:ja`. Wikidata gives
an abbreviation once per brand; OpenStreetMap gives it as often as a mapper
happened to write it, which is almost never. A matcher wanting abbreviations
should take Wikidata's and expect the map to be nearly silent.
