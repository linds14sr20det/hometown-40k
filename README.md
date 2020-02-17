# Hometown40K README

## What's Hometown40k anyways?
Hometown40k is an opensource website built to help Warhammer 40K players and tournament organizers run events. It feature an easily searchable event listings page, easy event registration and easy event management. If you want to help this project out please submit a pull request. Donation link coming soon!

## Setup instructions

### Prerequisites
* Ruby 2.6.3
* Postgres 10

### External Services
* Google Maps API (used for finding local events)
* AWS S3 (image storage, army list upload)
* Sendgrid (email communication with players, managed through Heroku)

### Setup
* run `git clone git@github.com:linds14sr20det/hometown-40k.git`
* run `bundle install`
* make a copy of `.env.development.sample` and rename it `.env.development` (update `.env` with any relevant credentials for services you want to run locally)
* run `rake db:create`
* run `rake db:migrate`
* optionally run `rake db:seed` if you want your db pre-seeded with fake data
