## 2020-10-28 -- Mike S.

Data for Great Backyard Bird Count from Global Biodiversity Information Facility (GBIF) 
Bird occurrence data from annual (Feb) weekend bird survey in US and Canada
\>7 million records; unzipped file size > 3 GB
https://www.gbif.org/search?q=Backyard%20Bird


## 2020-11-10 -- Jelmer 

- Explored the data a bit and extracted Ohio records:

```bash
## Input file: 
birds_org=../backyard-birds.csv # *NOT ON GITHUB - CHANGE TO OWN DIR*

## Output files:
birds_ohio=assets/data/birds/backyard-birds_Ohio_orig.tsv
all_cols=assets/data/birds/misc/all_cols.txt
nrecords_by_state=assets/data/birds/misc/nrecords-by-state.txt

# Check columns, State/Province is #18:
head -n 1 $birds_org | tr "\t" "\n" | nl > $all_cols

# Check nr of records by State, Ohio has 311,441:
tail -n +2 $birds_org | cut -f 18 | sort | uniq -c > $nrecords_by_state

# Extract Ohio records and remove unnecessary columns:
awk -F"\t" 'NR == 1 || $18 == "Ohio"' $birds_org | cut -f 6-10,17-18,22-23,30 > $birds_ohio

## Check output:
wc -l $birds_ohio   # 311,442 rows
ls -lh $birds_ohio  # 35 Mb
```


## 2020-11-13 -- Jelmer

- Added English names to the Ohio dataset in `assets/data/birds/backyard-birds_Ohio.tsv`.
  - Used an IOC (Int. Ornithological Committee) list for this which is at `assets/data/birds/master_ioc_list_v10.2.xlsx`.
  - Used the code in `assets/scripts/birds/02_birds_add-english-names.R` for this.
