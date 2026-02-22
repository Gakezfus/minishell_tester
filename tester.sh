
#!bin/bash

run_test()
{
local input="$1"
local name="$2"
local fail=0

echo "$name"

echo

bash < "$input" > bash.out 2> bash.err
local bash_status=$?

../minishell < "$input" > mini.out 2> mini.err
local mini_status=$?

diff -u bash.out mini.out || {
	echo "STDOUT mismatch"
	fail=1
}

diff -u bash.err mini.err || {
	echo "STDERR mismatch"
	fail=1
}

if [[ $bash_status -ne $mini_status ]]; then
        echo "EXIT mismatch: expected $bash_status got $mini_status"
		fail=1
fi

if [[ $fail -eq 0 ]]; then
		echo "OK"
fi

echo
}

for test in tests/*/*; do
    run_test "$test" "${test##*/}"
done
