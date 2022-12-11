#!/bin/bash

# NOTE: Add a pin directory before running this script!

if [[ $1 == 'na' ]]; then
# Test: NATIVE
echo "Running NATIVE tests"

cd gcd-list
rm -rf pin/na/
mkdir pin/na
mkdir pin/na/itrace
make MODE=na
mv gcd-list.na pin/bin/
make clean

objdump -S pin/bin/gcd-list.na > pin/bin/gcd-list_na.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './gcd-list/pin/bin/gcd-list.na 42' -2 './gcd-list/pin/bin/gcd-list.na 24' -o './gcd-list/pin/na'

START_INST_ADDR=$(grep '<_start>' ./gcd-list/pin/bin/gcd-list_na.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./gcd-list/pin/na/itrace/test1.out | head -n 1)

echo $START_INST_ADDR
echo $START_PIN_ADDR
python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff gcd-list/pin/na/

elif [[ $1 == "do_broken" ]]; then
# Test: DO_BROKEN
echo "Running DO_BROKEN tests"

cd gcd-list
rm -rf pin/do_broken/
mkdir pin/do_broken
mkdir pin/do_broken/itrace
make MODE=do_broken
mv gcd-list.do_broken pin/bin/
make clean

objdump -S pin/bin/gcd-list.do_broken > pin/bin/gcd-list_do_broken.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './gcd-list/pin/bin/gcd-list.do_broken 42' -2 './gcd-list/pin/bin/gcd-list.do_broken 24' -o './gcd-list/pin/do_broken'

START_INST_ADDR=$(grep '<_start>' ./gcd-list/pin/bin/gcd-list_do_broken.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./gcd-list/pin/do_broken/itrace/test1.out | head -n 1)

python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff gcd-list/pin/do_broken/

else
# Test: DO
echo "Running DO tests"

cd gcd-list
rm -rf pin/do/
mkdir pin/do
mkdir pin/do/itrace
make MODE=do
mv gcd-list.do pin/bin/
make clean

objdump -S pin/bin/gcd-list.do > pin/bin/gcd-list_do.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './gcd-list/pin/bin/gcd-list.do 42' -2 './gcd-list/pin/bin/gcd-list.do 24' -o './gcd-list/pin/do'

START_INST_ADDR=$(grep '<_start>' ./gcd-list/pin/bin/gcd-list_do.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./gcd-list/pin/do/itrace/test1.out | head -n 1)

python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff gcd-list/pin/do/

fi