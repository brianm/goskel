# per-project info
PACKAGE:=github.com/brianm/goskel
BINARY:=goskel

# shouldn't probably change between projects
WORKSPACE:=$(PWD)/_workspace

# this makefile is on the project branch, so we cannot lookup branch
# we want. Default to master and allow folks to switch it manually in
# the checked out repo after making the workspace. 
#
# In other words, leave this value alone!
BRANCH:=master

$(BINARY): workspace
	GOPATH=$(WORKSPACE) go install $(PACKAGE)
	cp $(WORKSPACE)/bin/$(BINARY) .

workspace: $(WORKSPACE)/src/$(PACKAGE)

$(WORKSPACE)/src/$(PACKAGE):
	mkdir -p $(WORKSPACE)/src/$(PACKAGE)
	git clone . $(WORKSPACE)/src/$(PACKAGE)
	cp .git/config $(WORKSPACE)/src/$(PACKAGE)/.git/
	cd $(WORKSPACE)/src/$(PACKAGE) && git checkout $(BRANCH)

activate: workspace
	@PROJECT="$(BINARY)" PACKAGE="$(PACKAGE)" /bin/bash ./local.bash activate

work: activate

clean:
	rm -f $(WORKSPACE)/bin/$(BINARY) $(BINARY)

dist-clean: clean
	rm -rf $(WORKSPACE) $(BINARY)
