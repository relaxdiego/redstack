## v0.0.2

###	Features

* Authenticate against back-end
* Token CRUD
* Project CRUD
* User CRUD

###	Improvements

* DONE: Re-arrange the files/namespace to RedStack::Service::Layer (e.g. RedStack::Identity::Controllers)
* Add travis and coveralls config file
* Make sure VCR config is by a redstack.yml config file and that it's set only once, at gem load time
* Modify Session so that it uses Identity::Controllers::TokensController for requesting tokens
* Extract common code in controllers and move to ArrayController and ObjectController
* WONTFIX: Consider moving service-specific session methods to their own files?
* DONE: Clean up gems, fix .ruby-version, .ruby-gemset files


## v0.0.1

* DONE: Nothing much. Just get the skeleton up and push to rubygems.org to secure the the name.