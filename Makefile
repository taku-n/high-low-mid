all: high-low-mid.ex5

high-low-mid.ex5: high-low-mid.mq5
	-metaeditor64.exe /compile:high-low-mid.mq5 /log:log.log
	cat log.log
	rm log.log
