#!/bin/env bash

/etc/init.d/tor start

python ./sqlmap.py $@