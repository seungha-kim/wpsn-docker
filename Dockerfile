FROM node:8-onbuild

ENTRYPOINT npx knex migrate:latest && npm start
