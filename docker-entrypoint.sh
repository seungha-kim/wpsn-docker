#!/bin/bash
set -e
npx knex migrate:latest
pm2-docker start --env production process.yml
