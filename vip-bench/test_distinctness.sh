#!/bin/bash

# NOTE: Add a pin directory before running this script!

echo "$1"

if [[ $1 == 'na' ]]; then
# Test: NATIVE
echo "Running NATIVE tests"

cd distinctness
rm -rf pin/na/
mkdir pin/na
mkdir pin/na/itrace
make MODE=na
mv distinctness.na pin/bin/
make clean

objdump -S pin/bin/distinctness.na > pin/bin/distinctness_na.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './distinctness/pin/bin/distinctness.na 8,7,9,6,2,0,1,3,5,4' -2 './distinctness/pin/bin/distinctness.na 8,7,9,2,2,0,1,3,5,4' -o './distinctness/pin/na'

START_INST_ADDR=$(grep '<_start>' ./distinctness/pin/bin/distinctness_na.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./distinctness/pin/na/itrace/test1.out | head -n 1)

echo $START_INST_ADDR
echo $START_PIN_ADDR
python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff distinctness/pin/na/

elif [[ $1 == "do_broken" ]]; then
# Test: DO_BROKEN
echo "Running DO_BROKEN tests"

cd distinctness
rm -rf pin/do_broken/
mkdir pin/do_broken
mkdir pin/do_broken/itrace
make MODE=do_broken
mv distinctness.do_broken pin/bin/
make clean

objdump -S pin/bin/distinctness.do_broken > pin/bin/distinctness_do_broken.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './distinctness/pin/bin/distinctness.do_broken 8,7,9,6,2,0,1,3,5,4' -2 './distinctness/pin/bin/distinctness.do_broken 8,7,9,2,2,0,1,3,5,4' -o './distinctness/pin/do_broken'

START_INST_ADDR=$(grep '<_start>' ./distinctness/pin/bin/distinctness_do_broken.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./distinctness/pin/do_broken/itrace/test1.out | head -n 1)

python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff distinctness/pin/do_broken/

else
# Test: DO
echo "Running DO tests"

cd distinctness
rm -rf pin/do/
mkdir pin/do
mkdir pin/do/itrace
make MODE=do
mv distinctness.do pin/bin/
make clean

objdump -S pin/bin/distinctness.do > pin/bin/distinctness_do.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './distinctness/pin/bin/distinctness.do 8,7,9,6,2,0,1,3,5,4' -2 './distinctness/pin/bin/distinctness.do 8,7,9,2,2,0,1,3,5,4' -o './distinctness/pin/do'

START_INST_ADDR=$(grep '<_start>' ./distinctness/pin/bin/distinctness_do.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./distinctness/pin/do/itrace/test1.out | head -n 1)

python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff distinctness/pin/do/

fi