#!/bin/bash
# Writes errors to log
for i in {1..9}
do
# The following should run without any errors unless the data itself changed
java io/sourceforge/curtthomas/isbn/Testing io/sourceforge/curtthomas/isbn/isbn10ok/test100$i 2>>errorslog
# To view errors (populate error file instead), comment out the preceding line, then uncomment  
# and run the following line (the ISBNs that caused errors occupy the respective files' tails):
#java io/sourceforge/curtthomas/isbn/Testing io/sourceforge/curtthomas/isbn/isbn10all/test100$i 2>>errorslog
done
for i in {10..94}
do
# The following should run without any errors unless the data itself changed
java io/sourceforge/curtthomas/isbn/Testing io/sourceforge/curtthomas/isbn/isbn10ok/test10$i 2>>errorslog
# To view errors (populate error file instead), comment out the preceding line, then uncomment  
# and run the following line (the ISBNs that caused errors occupy the respective files' tails):
#java io/sourceforge/curtthomas/isbn/Testing io/sourceforge/curtthomas/isbn/isbn10all/test10$i 2>>errorslog
done
for i in {1..9}
do
# The following should run without any errors unless the data itself changed	
java io/sourceforge/curtthomas/isbn/Testing io/sourceforge/curtthomas/isbn/isbn13ok/test130$i 2>>errorslog
# To view errors (populate error file instead), comment out the preceding line, then uncomment  
# and run the following line (the ISBNs that caused errors occupy the respective files' tails):
#java io/sourceforge/curtthomas/isbn/Testing io/sourceforge/curtthomas/isbn/isbn13all/test130$i 2>>errorslog
done
for i in {10..94}
do
# The following should run without any errors unless the data itself changed	
java io/sourceforge/curtthomas/isbn/Testing io/sourceforge/curtthomas/isbn/isbn13ok/test13$i 2>>errorslog
# To view errors (populate error file instead), comment out the preceding line, then uncomment  
# and run the following line (the ISBNs that caused errors occupy the respective files' tails):
#java io/sourceforge/curtthomas/isbn/Testing io/sourceforge/curtthomas/isbn/isbn13all/test13$i 2>>errorslog
done