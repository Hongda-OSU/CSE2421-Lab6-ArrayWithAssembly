#
# Hongda Lin: Assembly Makefile
# Modify Date: 10/4/2021

all:  tags headers


#*********************************************************

clean: 
	rm -rf *.o

# Build executable #

lab6: lab6.o
	gcc -g -o $@ $^

#*********************************************************

# building the zip file.

lab6.zip: makefile *.s
	zip lab6.zip makefile *.s readme
	rm –rf install
	# create the install folder
	mkdir install
	# unzip to the install folderunzip *.zip –d install
	unzip lab6.zip -d install
	# make ONLY the * target, not *.zip
	make –C install lab6

#*********************************************************

%.o: %.s
	gcc -g -m64 -c -o $@ $^

#*********************************************************
