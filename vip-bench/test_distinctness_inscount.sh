#!/bin/bash

# NOTE: Add a pin directory before running this script!

echo "$1"

cd distinctness-inscount
make clean
if [[ $1 == 'na' ]]; then
# Test: NATIVE
echo "Running NATIVE tests"
rm -rf pin/na
mkdir pin/na
mkdir pin/na/inscount
make MODE=na
mv distinctness.na pin/bin/

cd ../

pin='../../../../'

for((i=10; i<=40; i++))
do
test="./distinctness-inscount/pin/bin/distinctness.na ${i}"
$pin/pin -t $pin/source/tools/ManualExamples/obj-intel64/inscount1.so -- $test
cat inscount.out > "./distinctness-inscount/pin/na/inscount/inscount_${i}.out"

done

elif [[ $1 == "do_broken" ]]; then
# Test: DO_BROKEN
echo "Running DO_BROKEN tests"
rm -rf pin/do_broken
mkdir pin/do_broken
mkdir pin/do_broken/inscount
make MODE=do_broken
mv distinctness.do_broken pin/bin/
make clean

cd ../

pin='../../../../'

for((i=10; i<=40; i++))
do
test="./distinctness-inscount/pin/bin/distinctness.do_broken ${i}"
# $pin/pin -t $pin/source/tools/ManualExamples/obj-intel64/itrace.so -- $test
# cat itrace.out > "./distinctness-inscount/pin/do_broken/inscount/inscount_${i}.out"
$pin/pin -t $pin/source/tools/ManualExamples/obj-intel64/inscount1.so -- $test
cat inscount.out > "./distinctness-inscount/pin/do_broken/inscount/inscount_${i}.out"

done

else
# Test: DO
echo "Running DO tests"
rm -rf pin/do
mkdir pin/do
mkdir pin/do/inscount
make MODE=do
mv distinctness.do pin/bin/
make clean

cd ../

pin='../../../../'

for((i=10; i<=40; i++))
do
test="./distinctness-inscount/pin/bin/distinctness.do ${i}"
$pin/pin -t $pin/source/tools/ManualExamples/obj-intel64/inscount1.so -- $test
cat inscount.out > "./distinctness-inscount/pin/do/inscount/inscount_${i}.out"

done

fi