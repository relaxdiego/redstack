## v0.0.2 prototype 2

###	Features

* Token Create
* Project CRUD
* User CRUD
* Role CRUD


## v0.0.2 prototype 1 (ABANDONED)

### Notes
I'm going to re-design this library again due to the following:

* Originally, I wanted to keep the API simple by putting back-end calls directly inside the model. However, this can produce some weird stuff like using a token to validate another token (say what??). This is an early indicator telling me that the Model class will turn into this giant blob of methods.
* I should be re-using libraries like ActiveModel or ActiveAttr since it already has the methods that I'm using in my models
* I need to research on REST client libraries. I should be using those to define my clients for the various OpenStack services.

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