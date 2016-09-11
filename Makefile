
NIXPKGS_DRV = nix-instantiate --add-root `pwd`/.nixpkgs-drc --indirect -E "(import ./deploy/nixpkgs)"

NIXPKGS = $(shell set -e; nix-store --add-root `pwd`/.nixpkgs --indirect --realise $$($(NIXPKGS_DRV)))

NIXOPS = NIX_PATH=nixpkgs=$(NIXPKGS) nixops

create-vms: 
	$(NIXOPS) info -d sample-dev; \
	if [ $$? -ne 0 ]; then \
		$(NIXOPS) create ./deploy/machine.nix ./deploy/virtualbox-spec.nix -d sample-dev; \
	fi;
	$(eval new_vms := $(shell $(NIXOPS) info -d sample-dev | grep "Missing / New" | cut -d '|' -f 2 | paste -s))
	if [ "$(new_vms)" != "" ]; then \
		$(NIXOPS) deploy --force-reboot --include $(new_vms); \
	fi

deploy-vms: create-vms
	$(NIXOPS) deploy -d sample-dev
