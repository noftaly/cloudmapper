setup:
	pip install -r requirements.txt
test:
	bash tests/scripts/unit_tests.sh

cleancache:
	rm ./account-data/$(account)/**/{$(files)}.json
collect:
	python3 cloudmapper.py collect --account $(account) --profile $(profile)
prepare:
	python3 cloudmapper.py prepare --config config.json --account $(account) --internal-edges --inter-rds-edges
report:
	python3 cloudmapper.py report --config config.json --account $(account)
webserver:
	python3 cloudmapper.py webserver
open: # macOS only
	open http://127.0.0.1:8000
weball: prepare report webserver
remake: cleancache collect weball
