# Arugula

## Introduction

Arugula is a lead collection API.

## Getting Started

Create databases:

    createdb arugula_development
    createdb arugula_test

Set your database url:

    export DATABASE_URL=postgres://localhost/arugula_development
    # or
    export DATABASE_URL=postgres://localhost/arugula_test

Migrate database:

    sequel -m db/migrations $DATABASE_URL

Run tests:

    ruby app_test.rb

Run server:

    rackup

## API

* POST /users
* PUT /users/:id
