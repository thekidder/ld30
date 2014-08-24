#!/bin/bash

cd deploy
mv deploy.html index.html
scp * www-data@thekidder.com:/var/www/thekidder/ld30/