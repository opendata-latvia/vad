VAD
===

Development environment preparation
-----------------------------------

Prerequisites

* Ruby 1.9.3
* MySQL
* Redis

Get repository and get Ruby gem dependencies

* `git clone git@github.com:opendata-latvia/vad.git`
* `cd vad`
* `gem install bundler`
* `bundle`

Create and verify configuration files

* `cp config/application.sample.yml config/application.yml`
* `cp config/database.sample.yml config/database.yml`

Create MySQL database schema

* `rake db:create`
* `rake db:migrate`

Running tests

* Run all tests with `rake spec`
* Run tests after each file change with `bundle exec guard`

License
-------

VAD is released under the MIT license (see file LICENSE).
