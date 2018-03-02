high-low-mid.ex5: high-low-mid.mq5 high-low-mid.dll
	-metaeditor64.exe /compile:high-low-mid.mq5 /log:log.log
	cat log.log
	rm log.log

high-low-mid.dll: high-low-mid.c
	clang -Wall -shared -o high-low-mid.dll high-low-mid.c
