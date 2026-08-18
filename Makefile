.PHONY: clean

include .env

CLEAN_FOLDER := $(patsubst %/,%,$(FOLDER))
N := $(lastword $(subst -, ,$(CLEAN_FOLDER)))

clean:
	-find . -type f -name "*.exe" -delete
	-rm -rf build/

package: clean
	mkdir build/
	cp -r $(FOLDER)/** build/
	@for f in $$(find build/ -type f -name "*.f"); do \
		gfortran "$$f" -o "$${f%.f}.exe" || continue; \
	done
	mv "build/relatorio-$(N).pdf" "build/relatorio-$(N)-$(NUSP).pdf"
