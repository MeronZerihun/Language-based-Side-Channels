#!/bin/bash

# NOTE: Add a pin directory before running this script!

echo "$1"

if [[ $1 == 'na' ]]; then
# Test: NATIVE
echo "Running NATIVE tests"

cd boyer-moore-search
rm -rf pin/na/
mkdir pin/na
mkdir pin/na/itrace
make MODE=na
mv boyer-moore-search.na pin/bin/
make clean

objdump -S pin/bin/boyer-moore-search.na > pin/bin/boyer-moore-search_na.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './boyer-moore-search/pin/bin/boyer-moore-search.na abcabcabcabc ddd' -2 './boyer-moore-search/pin/bin/boyer-moore-search.na dddabcdddabc ddd' -o './boyer-moore-search/pin/na'

START_INST_ADDR=$(grep '<_start>' ./boyer-moore-search/pin/bin/boyer-moore-search_na.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./boyer-moore-search/pin/na/itrace/test1.out | head -n 1)

echo $START_INST_ADDR
echo $START_PIN_ADDR
python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff boyer-moore-search/pin/na/

elif [[ $1 == "do_broken" ]]; then
# Test: DO_BROKEN
echo "Running DO_BROKEN tests"

cd boyer-moore-search
rm -rf pin/do_broken/
mkdir pin/do_broken
mkdir pin/do_broken/itrace
make MODE=do_broken
mv boyer-moore-search.do_broken pin/bin/
make clean

objdump -S pin/bin/boyer-moore-search.do_broken > pin/bin/boyer-moore-search_do_broken.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './boyer-moore-search/pin/bin/boyer-moore-search.do_broken abcabcabcabc ddd' -2 './boyer-moore-search/pin/bin/boyer-moore-search.do_broken dddabcdddabc ddd' -o './boyer-moore-search/pin/do_broken'

START_INST_ADDR=$(grep '<_start>' ./boyer-moore-search/pin/bin/boyer-moore-search_do_broken.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./boyer-moore-search/pin/do_broken/itrace/test1.out | head -n 1)

python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff boyer-moore-search/pin/do_broken/

else
# Test: DO
echo "Running DO tests"

cd boyer-moore-search
rm -rf pin/do/
mkdir pin/do
mkdir pin/do/itrace
make MODE=do
mv boyer-moore-search.do pin/bin/
make clean

objdump -S pin/bin/boyer-moore-search.do > pin/bin/boyer-moore-search_do.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './boyer-moore-search/pin/bin/boyer-moore-search.do abcabcabcabc ddd' -2 './boyer-moore-search/pin/bin/boyer-moore-search.do dddabcdddabc ddd' -o './boyer-moore-search/pin/do'

START_INST_ADDR=$(grep '<_start>' ./boyer-moore-search/pin/bin/boyer-moore-search_do.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./boyer-moore-search/pin/do/itrace/test1.out | head -n 1)

python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff boyer-moore-search/pin/do/

fi