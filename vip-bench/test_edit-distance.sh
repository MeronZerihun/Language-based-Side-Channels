#!/bin/bash

# NOTE: Add a pin directory before running this script!

if [[ $1 == 'na' ]]; then
# Test: NATIVE
echo "Running NATIVE tests"

cd edit-distance
rm -rf pin/na/
mkdir pin/na
mkdir pin/na/itrace
make MODE=na
mv edit-distance.na pin/bin/
make clean

objdump -S pin/bin/edit-distance.na > pin/bin/edit-distance_na.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './edit-distance/pin/bin/edit-distance.na TAA GTT' -2 './edit-distance/pin/bin/edit-distance.na AAT AAT' -o './edit-distance/pin/na'

START_INST_ADDR=$(grep '<_start>' ./edit-distance/pin/bin/edit-distance_na.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./edit-distance/pin/na/itrace/test1.out | head -n 1)

echo $START_INST_ADDR
echo $START_PIN_ADDR
python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff edit-distance/pin/na/

elif [[ $1 == "do_broken" ]]; then
# Test: DO_BROKEN
echo "Running DO_BROKEN tests"

cd edit-distance
rm -rf pin/do_broken/
mkdir pin/do_broken
mkdir pin/do_broken/itrace
make MODE=do_broken
mv edit-distance.do_broken pin/bin/
make clean

objdump -S pin/bin/edit-distance.do_broken > pin/bin/edit-distance_do_broken.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './edit-distance/pin/bin/edit-distance.do_broken TAA GTT' -2 './edit-distance/pin/bin/edit-distance.do_broken AAT AAT' -o './edit-distance/pin/do_broken'

START_INST_ADDR=$(grep '<_start>' ./edit-distance/pin/bin/edit-distance_do_broken.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./edit-distance/pin/do_broken/itrace/test1.out | head -n 1)

python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff edit-distance/pin/do_broken/

else
# Test: DO
echo "Running DO tests"

cd edit-distance
rm -rf pin/do/
mkdir pin/do
mkdir pin/do/itrace
make MODE=do
mv edit-distance.do pin/bin/
make clean

objdump -S pin/bin/edit-distance.do > pin/bin/edit-distance_do.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './edit-distance/pin/bin/edit-distance.do TAA GTT' -2 './edit-distance/pin/bin/edit-distance.do AAT AAT' -o './edit-distance/pin/do'

START_INST_ADDR=$(grep '<_start>' ./edit-distance/pin/bin/edit-distance_do.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./edit-distance/pin/do/itrace/test1.out | head -n 1)

python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff edit-distance/pin/do/

fi