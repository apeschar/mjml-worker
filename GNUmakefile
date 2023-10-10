test :
	nix flake check
.PHONY : test

watch :
	git ls-files | entr -r -c $(MAKE) test
.PHONY : watch
