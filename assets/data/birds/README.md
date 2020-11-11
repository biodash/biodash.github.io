## Mike S.

Data for Great Backyard Bird Count from Global Biodiversity Information Facility (GBIF) 
Bird occurrence data from annual (Feb) weekend bird survey in US and Canada
>7 million records; unzipped file size > 3 GB
https://www.gbif.org/search?q=Backyard%20Bird

## Jelmer - 2020-11-10

- Explore the data a bit and extract Ohio:

```bash
birds_org=assets/data/birds/backyard-birds.csv
birds_ohio=assets/data/birds/backyard-birds_Ohio.tsv
all_cols=assets/data/birds/all_cols.txt
nrecords_by_state=assets/data/birds/nrecords-by-state.txt
head -n 1 $birds_org | tr "\t" "\n" | nl > $all_cols # Check columns, State/Province is #18
tail -n +2 $birds_org | cut -f 18 | sort | uniq -c > $nrecords_by_state # Check nr of records by State, Ohio has 311,441
awk -F"\t" 'NR == 1 || $18 == "Ohio"' $birds_org | cut -f 6-10,17-18,22-23,30 > $birds_ohio
wc -l $birds_ohio   # 311,442 rows
ls -lh $birds_ohio  # 35 Mb
```
