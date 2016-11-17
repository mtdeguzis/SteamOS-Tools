#!/bin/bash

sed -i 's/-q --show-progress -nc/-nc/g' configure-repos.sh
./configure-repos.sh && ./configure-repos.sh --remove
./configure-repos.sh --enable-testing && ./configure-repos.sh --remove-testing
./configure-repos.sh --enable-testing && ./configure-repos.sh --remove
./configure-repos.sh --default && ./configure-repos.sh --remove
./configure-repos.sh --repair && ./configure-repos.sh --remove
./configure-repos.sh
