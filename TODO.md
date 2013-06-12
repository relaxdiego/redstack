## v0.0.2

###	Features

* DONE: Authenticate against back-end
* DONE: Token Create
* DONE: Project CRUD
* User CRUD

###	Improvements

* DONE: Re-arrange the files/namespace to RedStack::Service::Layer (e.g. RedStack::Identity::Controllers)
* DONE: Add travis and coveralls config file
* DONE: Make sure VCR config is enabled by a redstack.yml config file and that it's set only once, at gem load time
* WONTFIX: Consider moving service-specific session methods to their own files?
* DONE: Clean up gems, fix .ruby-version, .ruby-gemset files
* DONE: Modify Session so that it uses Identity::Models::Token for requesting tokens
* WONTFIX: Extract common code in controllers and move to ArrayController and ObjectController
* DONE: Merge Token::create with Model::create
* Use the cleaner way to define class methods
* In the tests, rename the 'querystring' param to the more obvious 'vcr_signature'
* Add cane gem and fix all violations

## v0.0.1

* DONE: Nothing much. Just get the skeleton up and push to rubygems.org to secure the the name.