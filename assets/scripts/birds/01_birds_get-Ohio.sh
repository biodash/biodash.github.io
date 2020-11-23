## Input file: *NOT ON GITHUB - CHANGE TO OWN DIR*
birds_org=../backyard-birds.csv

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