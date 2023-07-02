#!/usr/bin/env python

import hashlib
import sys
import requests
import yaml

REPO = "KRTirtho/spotube"
YAML_FILENAME = "com.github.KRTirtho.Spotube.yml"

config = None
with open(YAML_FILENAME, mode="r", encoding="utf-8") as input:
    config = yaml.safe_load(input)

# Requires the 2nd VERSION argument to be passed
version = sys.argv[1:][0]


tar_url = f"https://github.com/{REPO}/releases/download/v{version}/spotube-linux-{version}-x86_64.tar.xz"
tar_sha256 = hashlib.sha256()
print(f"Downloading file {tar_url} to generete sha256 sum")
tar = requests.get(tar_url)
for chunk in tar.iter_content():
    if chunk:
        tar_sha256.update(chunk)

tar_source = config["modules"][-1]["sources"][0]
tar_source["url"] = tar_url
tar_source["sha256"] = tar_sha256.hexdigest()

with open(YAML_FILENAME, mode="w", encoding="utf-8") as output:
    yaml.safe_dump(config, output, sort_keys=False)