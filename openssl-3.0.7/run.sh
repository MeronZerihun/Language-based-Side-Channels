#!/bin/bash

# rm *.txt.enc
# rm *.txt.new
# rm *.out

# Export the directory for shared libraries
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$OPENSSL_HOME/openssl/lib64/

OPENSSL=$OPENSSL_HOME/openssl/bin/openssl

# Test command
# $OPENSSL help

$OPENSSL  aes-256-cbc -a -salt -pbkdf2 -in my_file.txt -out itrace_my_file1.txt.enc -k abc
$OPENSSL aes-256-cbc -d -a -pbkdf2 -in itrace_my_file1.txt.enc -out itrace_my_file1.txt.new -k abc

# -pbkdf2             Password-based key derivation function
#  ------ Test 1: Using password abc ------
# Encryption   
../../../../pin -t ../obj-intel64/itrace.so -- $OPENSSL aes-256-cbc -a -salt -pbkdf2 -in my_file.txt -out itrace_my_file1.txt.enc -k abc
cat itrace.out > itrace/openssl_enc_test1.out
echo "Test 1: Encryption done!";
# Decryption
../../../../pin -t ../obj-intel64/itrace.so -- $OPENSSL aes-256-cbc -d -a -pbkdf2 -in itrace_my_file1.txt.enc -out itrace_my_file1.txt.new -k abc
cat itrace.out > itrace/openssl_dec_test1.out
echo "Test 1: Decryption done!";

#  ------ Test 2: Using password 12345678 ------
# Encryption    
../../../../pin -t ../obj-intel64/itrace.so -- $OPENSSL aes-256-cbc -a -salt -pbkdf2 -in my_file.txt -out itrace_my_file2.txt.enc -k 12345678
cat itrace.out > itrace/openssl_enc_test2.out
echo "Test 2: Encryption done!";

# Decryption
../../../../pin -t ../obj-intel64/itrace.so -- $OPENSSL aes-256-cbc -d -a -pbkdf2 -in itrace_my_file2.txt.enc -out itrace_my_file2.txt.new -k 12345678
cat itrace.out > itrace/openssl_dec_test2.out
echo "Test 2: Decryption done!";

# #  ------ Test 3: Using password 123 ------
# ../../../../pin -t ../obj-intel64/itrace.so -- $OPENSSL aes-256-cbc -a -salt -pbkdf2 -in my_file.txt -out itrace_my_file3.txt.enc -k 123
# cat itrace.out > itrace/openssl_enc_test3.out
# echo "Test 3: Encryption done!";
# # Decryption
# ../../../../pin -t ../obj-intel64/itrace.so -- $OPENSSL aes-256-cbc -d -a -pbkdf2 -in itrace_my_file3.txt.enc -out itrace_my_file3.txt.new -k 123
# cat itrace.out > itrace/openssl_dec_test3.out
# echo "Test 3: Decryption done!";

echo "Starting to test for differences";
# Differences in itraces
diff --speed-large-files itrace/openssl_enc_test1.out itrace/openssl_enc_test2.out > itrace_openssl_enc_diff.out

# Differences in mem-traces
echo "Tests done!";

#  Use -S to add source code
objdump -S $OPENSSL > openssl_new.dump
