#!/bin/bash

# NOTE: Add a pin directory before running this script!

echo "$1"

if [[ $1 == 'na' ]]; then
# Test: NATIVE
echo "Running NATIVE tests"

cd distinctness-inscount
rm -rf pin/na/
mkdir pin/na
mkdir pin/na/itrace
make MODE=na
mv distinctness.na pin/bin/
make clean

objdump -S pin/bin/distinctness.na > pin/bin/distinctness_na.dump

cd ../
test1="./distinctness-inscount/pin/bin/distinctness.na 1"
test2="./distinctness-inscount/pin/bin/distinctness.na 10"
./auto-pin.sh -p '../../../../' -1 $test1 -2 $test2 -o './distinctness-inscount/pin/na'

START_INST_ADDR=$(grep '<_start>' ./distinctness-inscount/pin/bin/distinctness_na.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./distinctness-inscount/pin/na/itrace/test1.out | head -n 1)

echo $START_INST_ADDR
echo $START_PIN_ADDR
python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff distinctness-inscount/pin/na/

elif [[ $1 == "do_broken" ]]; then
# Test: DO_BROKEN
echo "Running DO_BROKEN tests"

cd distinctness-inscount
# rm -rf pin/do_broken/
mkdir pin/do_broken
mkdir pin/do_broken/itrace
make MODE=do_broken
mv distinctness.do_broken pin/bin/
make clean

objdump -S pin/bin/distinctness.do_broken > pin/bin/distinctness_do_broken.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './distinctness-inscount/pin/bin/distinctness.do_broken 1' -2 './distinctness-inscount/pin/bin/distinctness.do_broken 3' -o './distinctness-inscount/pin/do_broken'

START_INST_ADDR=$(grep '<_start>' ./distinctness-inscount/pin/bin/distinctness_do_broken.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./distinctness-inscount/pin/do_broken/itrace/test1.out | head -n 1)
echo $START_INST_ADDR
echo $START_PIN_ADDR

python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff distinctness-inscount/pin/do_broken/

else
# Test: DO
echo "Running DO tests"

cd distinctness-inscount
rm -rf pin/do/
mkdir pin/do
mkdir pin/do/itrace
make MODE=do
mv distinctness.do pin/bin/
make clean

objdump -S pin/bin/distinctness.do > pin/bin/distinctness_do.dump

cd ../
test1="./distinctness-inscount/pin/bin/distinctness.do 1"
test2="./distinctness-inscount/pin/bin/distinctness.do 10"
./auto-pin.sh -p '../../../../' -1 $test1 -2 $test2 -o './distinctness-inscount/pin/do'

START_INST_ADDR=$(grep '<_start>' ./distinctness-inscount/pin/bin/distinctness_do.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./distinctness-inscount/pin/do/itrace/test1.out | head -n 1)
echo $START_INST_ADDR
echo $START_PIN_ADDR

python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff distinctness-inscount/pin/do/

fi