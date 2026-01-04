#!/bin/env bash

/etc/init.d/tor start

uv run ./sqlmap.py $@