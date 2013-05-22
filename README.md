# RedStack

A Ruby binding for the OpenStack API.

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
tenants = os.tenants.get :all
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
