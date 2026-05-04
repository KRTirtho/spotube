#!/usr/bin/env python

import hashlib
import sys
import requests
import yaml
import os
from datetime import datetime

REPO = "KRTirtho/spotube"
YAML_FILENAME = "com.github.KRTirtho.Spotube.yml"


def download_and_update(version):
    with open(YAML_FILENAME, mode="r", encoding="utf-8") as input_file:
        config = yaml.safe_load(input_file)

    tar_url = f"https://github.com/{REPO}/releases/download/v{version}/spotube-linux-{version}-x86_64.tar.xz"
    tar_sha256 = hashlib.sha256()

    print(f"Downloading: {tar_url}")

    try:
        response = requests.get(tar_url, stream=True, timeout=10)
        response.raise_for_status()
    except requests.exceptions.RequestException as e:
        print(f"Download failed: {e}")
        sys.exit(1)

    total_size = int(response.headers.get("content-length", 0))
    downloaded = 0

    for chunk in response.iter_content(chunk_size=8192):
        if chunk:
            tar_sha256.update(chunk)
            downloaded += len(chunk)
            if total_size:
                percent = (downloaded / total_size) * 100
                print(f"\rProgress: {percent:.2f}%", end="")

    print("\nDownload complete.")

    tar_source = config["modules"][-1]["sources"][0]
    tar_source["url"] = tar_url
    tar_source["sha256"] = tar_sha256.hexdigest()

    backup_name = f"{YAML_FILENAME}.{datetime.now().strftime('%Y%m%d_%H%M%S')}.bak"
    os.rename(YAML_FILENAME, backup_name)
    print(f"Backup created: {backup_name}")

    with open(YAML_FILENAME, mode="w", encoding="utf-8") as output_file:
        yaml.safe_dump(config, output_file, sort_keys=False)

    print("YAML file updated successfully.")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python script.py <version>")
        sys.exit(1)

    version_arg = sys.argv[1]
    download_and_update(version_arg)
