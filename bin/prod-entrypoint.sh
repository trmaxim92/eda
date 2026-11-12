#!/bin/bash
set -e

bundle exec rails db:prepare
bundle exec rails db:seed

exec "$@"
