program_name="./parser"
test_file_name="test.c"

testcases=`ls encrypted_testcases/*.enc`
if [ $# != 0 ]; then
	testcases=($*)
fi


make

if [ $? != 0 ]; then
	echo "Error in make."
	exit
fi

echo

read -s -p "Enter password: " password
echo

for i in ${testcases[@]}; do
    i=`basename $i`
	rm -f $test_file_name
	openssl des3 -d -salt -in "encrypted_testcases/${i}" -out ${test_file_name} -pass "pass:${password}"
	if [ $? != 0 ]; then
		echo "Error in decrypting file ${i}"
		break
	else
		echo
		echo "------ Running test file : ${i} -------"
		echo

		eval "${program_name} < ${test_file_name}"
		echo
		
		echo "-----------------------------------------------"
                echo " GCC Produces:"
		openssl des3 -d -salt -in "encrypted_testcases/${i}.exp" -pass "pass:${password}"
		echo "-----------------------------------------------"

		rm -f $test_file_name

		read -p "Continue? [y/n] : " response
		if [ x${response} == "xn" ]; then
			break
		fi
	fi
done


