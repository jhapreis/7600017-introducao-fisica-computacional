include .env

SRCS := $(shell find $(FOLDER) -type f -name "*.f")
EXES := $(SRCS:.f=.exe)

clean:
	-rm -rf */**.out */**.exe

package: clean $(EXES)

%.exe: %.f
	gfortran $< -o $@
