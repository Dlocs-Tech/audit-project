#!/bin/sh
cast abi-encode "f(bytes4[])" "[$(jq -r '.methodIdentifiers | . | join(",")' ./out/$@.sol/$@.json)]"
