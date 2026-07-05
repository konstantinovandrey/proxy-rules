SING_BOX_RULES := /home/andrey/.config/sing-box/rules
SING_BOX_CONF := /home/andrey/.config/sing-box/config.json

.PHONY: build install restart update all

# Build all rule-sets from YAML source
build:
	./scripts/build.sh

# Install compiled rules into active sing-box config dir
install: build
	mkdir -p $(SING_BOX_RULES)
	cp build/*.srs $(SING_BOX_RULES)/
	# Also sync Clash YAML (used by Hiddify etc.)
	cp rules/direct.yaml dist/clash/direct.yaml
	cp rules/proxy.yaml dist/clash/proxy.yaml
	cp rules/reject.yaml dist/clash/reject.yaml
	cp rules/private.yaml dist/clash/private.yaml
	@echo "✓ Installed: $(SING_BOX_RULES)/"

# Restart the running sing-box service (sudo)
restart:
	sudo systemctl restart sing-box.service
	@echo "✓ sing-box restarted"

# Full cycle: build → install → restart
update: install restart
	@echo "✓ Proxy rules updated and applied"

# Alias
all: update
