#!/bin/bash
if which pscp > /dev/null; then
  pscp -r build/web/* www-data@thekidder.com:/var/www/thekidder/ld30/
else
  scp -r build/web/* www-data@thekidder.com:/var/www/thekidder/ld30/
fi