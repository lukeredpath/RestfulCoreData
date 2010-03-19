# Project overview
This app uses the [Pivotal Tracker][1] API to explore synching data from a remote API
to a local CoreData store.

## Requirements
To get it running you'll need a Pivotal Tracker account and an API key. Once you've
got your key, create a `Constants.h` in the root of your project (the project will not
build without this) and add the following line to it

    #define PT_API_KEY @"YOUR_API_KEY"

Obviously if this was a real app, the API key would be obtained via user input instead,
but this isn't a *real* app, is it?

You'll also need the latest version of the [HTTPRiot][2] library, which should be copied
to ~/Library/SDKs.

## What is the point?

The fact that this app uses the Pivotal Tracker API isn't really that relevant. The
point is to have a reusable means of synching a remote API to a local CoreData stack.

I'm using the HTTPRiot to access the API as its an awesome library for interacting with
JSON/XML REST APIs. There is a degree of coupling to its HRRestModel class at the moment
but that can be refactored away; its not that important right now.

[1]: http://pivotaltracker.com
[2]: http://labratrevenge.com/httpriot/docs/
