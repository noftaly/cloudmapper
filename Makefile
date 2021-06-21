connections=all

setup:
	pip install -r requirements.txt
test:
	bash tests/scripts/unit_tests.sh

cleancache:
	rm ./account-data/$(account)/**/{$(files)}.json
cleancacheall:
	rm -rf ./account-data/$(account)/
collect:
	python3 cloudmapper.py collect --account $(account) --profile $(profile)
collecteu:
	python3 cloudmapper.py collect --account $(account) --profile $(profile) --regions eu-west-3
prepare:
	python3 cloudmapper.py prepare --config config.json --account $(account) --internal-edges --inter-rds-edges --connections $(connections)
report:
	python3 cloudmapper.py report --config config.json --account $(account)
webserver:
	python3 cloudmapper.py webserver
weball: prepare webserver
remake: cleancache collect weball
remakeall: cleancacheall collecteu weball
