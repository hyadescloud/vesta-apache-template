#!/bin/bash

# Reset any modification just in case
git reset --hard
# Pull latest updates
git pull

# Set the correct permission
chmod a+x *.sh
chmod a+x common/*.sh

