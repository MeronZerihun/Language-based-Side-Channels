#!/bin/bash

# NOTE: Add a pin directory before running this script!

if [[ $1 == 'na' ]]; then
# Test: NATIVE
echo "Running NATIVE tests"

cd primal-test
rm -rf pin/na/
mkdir pin/na
mkdir pin/na/itrace
make MODE=na
mv primal-test.na pin/bin/
make clean

objdump -S pin/bin/primal-test.na > pin/bin/primal-test_na.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './primal-test/pin/bin/primal-test.na 42' -2 './primal-test/pin/bin/primal-test.na 24' -o './primal-test/pin/na'

START_INST_ADDR=$(grep '<_start>' ./primal-test/pin/bin/primal-test_na.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./primal-test/pin/na/itrace/test1.out | head -n 1)

echo $START_INST_ADDR
echo $START_PIN_ADDR
python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff primal-test/pin/na/

elif [[ $1 == "do_broken" ]]; then
# Test: DO_BROKEN
echo "Running DO_BROKEN tests"

cd primal-test
rm -rf pin/do_broken/
mkdir pin/do_broken
mkdir pin/do_broken/itrace
make MODE=do_broken
mv primal-test.do_broken pin/bin/
make clean

objdump -S pin/bin/primal-test.do_broken > pin/bin/primal-test_do_broken.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './primal-test/pin/bin/primal-test.do_broken 42' -2 './primal-test/pin/bin/primal-test.do_broken 24' -o './primal-test/pin/do_broken'

START_INST_ADDR=$(grep '<_start>' ./primal-test/pin/bin/primal-test_do_broken.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./primal-test/pin/do_broken/itrace/test1.out | head -n 1)

python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff primal-test/pin/do_broken/

else
# Test: DO
echo "Running DO tests"

cd primal-test
rm -rf pin/do/
mkdir pin/do
mkdir pin/do/itrace
make clean
make MODE=do
mv primal-test.do pin/bin/

objdump -S pin/bin/primal-test.do > pin/bin/primal-test_do.dump

cd ../
./auto-pin.sh -p '../../../../' -1 './primal-test/pin/bin/primal-test.do 42' -2 './primal-test/pin/bin/primal-test.do 24' -o './primal-test/pin/do'

START_INST_ADDR=$(grep '<_start>' ./primal-test/pin/bin/primal-test_do.dump | grep -E -o '0\w+' )
START_PIN_ADDR=$(grep 0x55 ./primal-test/pin/do/itrace/test1.out | head -n 1)

python3 get_code.py -trace $START_PIN_ADDR -code 0x$START_INST_ADDR -diff primal-test/pin/do/

fi