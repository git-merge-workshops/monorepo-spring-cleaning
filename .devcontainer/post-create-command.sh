#!/bin/sh
cd /source
cp -r a-bad-monorepo-clean a-bad-monorepo-filter-repo
cp -r a-bad-monorepo-clean a-bad-monorepo-lfs
cp -r a-bad-monorepo-clean a-bad-monorepo-graft
mv a-bad-monorepo-clean a-bad-monorepo