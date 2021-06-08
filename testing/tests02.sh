#!/bin/bash
# Compares original file and that written by testing.js
# Cannot run unless tests01.sh has run
# Before this script can run, npm install --save line-reader followed 
# by npm install node-line-reader will be necessary if node-line-reader is not installed already
# The temp01 directory needs to be cleared of files that have names beginning with "testing" 
# between runs, because the files in question are appended to not clobbered by testing.js
for i in {1..9}
do
node io/sourceforge/curtthomas/isbn/testing.js io/sourceforge/curtthomas/isbn/temp01/test130${i}json
echo io/sourceforge/curtthomas/isbn/isbn13ok/test130$i io/sourceforge/curtthomas/isbn/temp01/testing130$i >> difflog
diff io/sourceforge/curtthomas/isbn/isbn13ok/test130$i io/sourceforge/curtthomas/isbn/temp01/testing130$i >> difflog
done
for i in {10..94}
do
node io/sourceforge/curtthomas/isbn/testing.js io/sourceforge/curtthomas/isbn/temp01/test13${i}json
echo io/sourceforge/curtthomas/isbn/isbn13ok/test13$i io/sourceforge/curtthomas/isbn/temp01/testing13$i >> difflog
diff io/sourceforge/curtthomas/isbn/isbn13ok/test13$i io/sourceforge/curtthomas/isbn/temp01/testing13$i >> difflog
done
for i in {1..9}
do
node io/sourceforge/curtthomas/isbn/testing.js io/sourceforge/curtthomas/isbn/temp01/test100${i}json
grep -P -o '(?<=978)\d{9}' io/sourceforge/curtthomas/isbn/temp01/testing100$i > io/sourceforge/curtthomas/isbn/temp02/testing100$i
grep -P -o '\d{9}' io/sourceforge/curtthomas/isbn/isbn10ok/test100$i > io/sourceforge/curtthomas/isbn/temp02/test100$i
echo io/sourceforge/curtthomas/isbn/temp02/test100$i io/sourceforge/curtthomas/isbn/temp02/testing100$i >> difflog
diff io/sourceforge/curtthomas/isbn/temp02/test100$i io/sourceforge/curtthomas/isbn/temp02/testing100$i >> difflog
# Putatively checks whether ISBNs in file written by testing.js are valid
java io.sourceforge.curtthomas.isbn.CheckValid io/sourceforge/curtthomas/isbn/temp01/testing100$i 2>>validlog
done
for i in {10..94}
do
node io/sourceforge/curtthomas/isbn/testing.js io/sourceforge/curtthomas/isbn/temp01/test10${i}json
grep -P -o '(?<=978)\d{9}' io/sourceforge/curtthomas/isbn/temp01/testing10$i > io/sourceforge/curtthomas/isbn/temp02/testing10$i
grep -P -o '\d{9}' io/sourceforge/curtthomas/isbn/isbn10ok/test10$i > io/sourceforge/curtthomas/isbn/temp02/test10$i
echo io/sourceforge/curtthomas/isbn/temp02/test10$i io/sourceforge/curtthomas/isbn/temp02/testing10$i >> difflog
diff io/sourceforge/curtthomas/isbn/temp02/test10$i io/sourceforge/curtthomas/isbn/temp02/testing10$i >> difflog
# Putatively checks whether ISBNs in file written by testing.js are valid
java io.sourceforge.curtthomas.isbn.CheckValid io/sourceforge/curtthomas/isbn/temp01/testing10$i 2>>validlog
done