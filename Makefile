.PHONY: clean

include .env

CLEAN_FOLDER := $(patsubst %/,%,$(FOLDER))
N := $(lastword $(subst -, ,$(CLEAN_FOLDER)))

clean:
	-find . -type f -name "*.exe" -delete
	-find . -type f -name "*.out" -delete
# 	-find . -type f -name "*.dat" -delete
	-rm -rf build/

package: clean
	mkdir build/
	cp -r $(FOLDER)/** build/
	@for f in $$(find build/ -type f -name "*.f"); do \
		exe="$${f%.f}.exe"; \
		gfortran "$$f" -o "$$exe" || continue; \
		dir=$$(dirname "$$exe"); \
		base=$$(basename "$$exe"); \
		(cd "$$dir" && ./"$$base"); \
	done
	mv "build/relatorio-$(N).pdf" "build/relatorio-$(N)-$(NUSP).pdf"
