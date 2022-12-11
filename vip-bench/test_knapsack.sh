#!/bin/bash

# NOTE: Add a pin directory before running this script!

if [[ $1 == 'na' ]]; then
# Test: NATIVE
echo "Running NATIVE tests"

cd knapsack
rm -rf pin/na/
mkdir pin/na
mkdir pin/na/itrace
make MODE=na
mv knapsack.na pin/bin/
make clean

objdump -S pin/bin/knapsack.na > pin/bin/knapsack_na.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './knapsack/pin/bin/knapsack.na 20,80,100 10,40,30' -2 './knapsack/pin/bin/knapsack.na 60,100,120 10,20,30' -o './knapsack/pin/na'

START_INST_ADDR=$(grep '<_start>' ./knapsack/pin/bin/knapsack_na.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./knapsack/pin/na/itrace/test1.out | head -n 1)

echo $START_INST_ADDR
echo $START_PIN_ADDR
python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff knapsack/pin/na/

elif [[ $1 == "do_broken" ]]; then
# Test: DO_BROKEN
echo "Running DO_BROKEN tests"

cd knapsack
rm -rf pin/do_broken/
mkdir pin/do_broken
mkdir pin/do_broken/itrace
make MODE=do_broken
mv knapsack.do_broken pin/bin/
make clean

objdump -S pin/bin/knapsack.do_broken > pin/bin/knapsack_do_broken.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './knapsack/pin/bin/knapsack.do_broken 20,80,100 10,40,30' -2 './knapsack/pin/bin/knapsack.do_broken 60,100,120 10,20,30' -o './knapsack/pin/do_broken'

START_INST_ADDR=$(grep '<_start>' ./knapsack/pin/bin/knapsack_do_broken.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./knapsack/pin/do_broken/itrace/test1.out | head -n 1)

python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff knapsack/pin/do_broken/

else
# Test: DO
echo "Running DO tests"

cd knapsack
rm -rf pin/do/
mkdir pin/do
mkdir pin/do/itrace
make MODE=do
mv knapsack.do pin/bin/
make clean

objdump -S pin/bin/knapsack.do > pin/bin/knapsack_do.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './knapsack/pin/bin/knapsack.do 20,80,100 10,40,30' -2 './knapsack/pin/bin/knapsack.do 60,100,120 10,20,30' -o './knapsack/pin/do'

START_INST_ADDR=$(grep '<_start>' ./knapsack/pin/bin/knapsack_do.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./knapsack/pin/do/itrace/test1.out | head -n 1)

python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff knapsack/pin/do/

fi