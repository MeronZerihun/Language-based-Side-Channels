#!/bin/bash

# NOTE: Add a pin directory before running this script!

echo "$1"

if [[ $1 == 'na' ]]; then
# Test: NATIVE
echo "Running NATIVE tests"

cd bubble-sort
rm -rf pin/na/
mkdir pin/na
mkdir pin/na/itrace
make MODE=na
mv bubble-sort.na pin/bin/
make clean

objdump -S pin/bin/bubble-sort.na > pin/bin/bubble-sort_na.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './bubble-sort/pin/bin/bubble-sort.na 42' -2 './bubble-sort/pin/bin/bubble-sort.na 24' -o './bubble-sort/pin/na'

START_INST_ADDR=$(grep '<_start>' ./bubble-sort/pin/bin/bubble-sort_na.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./bubble-sort/pin/na/itrace/test1.out | head -n 1)

echo $START_INST_ADDR
echo $START_PIN_ADDR
python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff bubble-sort/pin/na/

elif [[ $1 == "do_broken" ]]; then
# Test: DO_BROKEN
echo "Running DO_BROKEN tests"

cd bubble-sort
rm -rf pin/do_broken/
mkdir pin/do_broken
mkdir pin/do_broken/itrace
rm -rf pin/do_broken/addr_code_itrace_diff.out
make MODE=do_broken
mv bubble-sort.do_broken pin/bin/
make clean

objdump -S pin/bin/bubble-sort.do_broken > pin/bin/bubble-sort_do_broken.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './bubble-sort/pin/bin/bubble-sort.do_broken 42' -2 './bubble-sort/pin/bin/bubble-sort.do_broken 24' -o './bubble-sort/pin/do_broken'

START_INST_ADDR=$(grep '<_start>' ./bubble-sort/pin/bin/bubble-sort_do_broken.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./bubble-sort/pin/do_broken/itrace/test1.out | head -n 1)

python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff bubble-sort/pin/do_broken/

else
# Test: DO
echo "Running DO tests"

cd bubble-sort
rm -rf pin/do/
mkdir pin/do
mkdir pin/do/itrace
make MODE=do
mv bubble-sort.do pin/bin/
make clean

objdump -S pin/bin/bubble-sort.do > pin/bin/bubble-sort_do.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './bubble-sort/pin/bin/bubble-sort.do 42' -2 './bubble-sort/pin/bin/bubble-sort.do 24' -o './bubble-sort/pin/do'

START_INST_ADDR=$(grep '<_start>' ./bubble-sort/pin/bin/bubble-sort_do.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./bubble-sort/pin/do/itrace/test1.out | head -n 1)

python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff bubble-sort/pin/do/

fi