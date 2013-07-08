# RedStack

A Ruby binding for the OpenStack API.

[![Code Climate](https://codeclimate.com/github/relaxdiego/redstack.png)](https://codeclimate.com/github/relaxdiego/redstack)
[![Build Status](https://travis-ci.org/relaxdiego/redstack.png)](https://travis-ci.org/relaxdiego/redstack) 
[![Coverage Status](https://coveralls.io/repos/relaxdiego/redstack/badge.png?branch=develop)](https://coveralls.io/r/relaxdiego/redstack?branch=develop)

## Installation

Add this line to your application's Gemfile:

    gem 'redstack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redstack

## Usage

```ruby
require 'redstack'

# Define a Keystone connection
ks = RedStack::Identity.new host: 'http://myopenstackinstance.com:5000', api_version: 'v2.0'

# Authenticate against Keystone
token = ks.authenticate username: 'johndoe', password: 'gu29qa!'

# Get a list of tenants/projects you have access to
projects = ks.get_projects

#Create a project (Requires token with admin access)
ks.authenticate username: 'johndoe', password: 'adfw@1', tenant: 'my_project'
project = ks.create_project name: 'New Project', description: 'My awesome project', enabled: true

# Get all projects in the system  (Requires token with admin access)
ks.authenticate username: 'johndoe', password: 'adfw@1', tenant: 'my_project'
projects = ks.get_projects select: :all

# Re-use token in other services
ks.authenticate username: 'johndoe', password: 'adfw@1', tenant: 'my_project'
nc = RedStack::Compute.new token: ks.token
servers = nc.find_servers

# ...or Re-use it in a new Keystone instance
ks2 = RedStack::Identity.new token: ks.token
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Setting Up Your Local Dev Environment
A few requirements before proceeding:

* RVM
* git
* growl on Mac OS X

Once the above have been installed, go to the RedStack project directory and install the required gems:

```
bundle install
```

Now you can start developing! Open the project folder with your favorit text editor, then, on your terminal, run guard from the project directory:

```
bundle exec guard
```
