# RedStack

A Ruby binding for the OpenStack API.

[![Code Climate](https://codeclimate.com/github/relaxdiego/redstack.png)](https://codeclimate.com/github/relaxdiego/redstack)

## Installation

Add this line to your application's Gemfile:

    gem 'redstack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redstack

## Usage

Create a new OpenStack session. 
```
os = RedStack::Session.new host: 'http://myopenstackinstance.com:5000', api_version: 'v2.0'
```

Authenticate against the identity service
```
os.authenticate username: 'johndoe', password: 'gu29qa!'
```

Get a list of tenants/projects you have access to
```
tenants = os.tenants.get_all
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