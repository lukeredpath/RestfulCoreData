# Project overview
This app uses the uses a basic Rails 3 app with a REST API to explore synching data from a remote API to a local CoreData store.

## Requirements
To get up and running, you'll need the latest Rails 3 beta (to run the demo app). To start up a server for the demo app, inside the SampleRestApp folder, run the following command:

    rails server
    
This will boot up a local server on port 3000, which the iPhone app is configured to use.

You'll also need the latest version of the [HTTPRiot][1] library, which should be copied
to ~/Library/SDKs.

## What is the point?

The point is to have a reusable means of synching a remote API to a local CoreData stack.

I'm using the HTTPRiot to access the API as its an awesome library for interacting with JSON/XML REST APIs. There is a degree of coupling to its HRRestModel class at the moment but that can be refactored away; its not that important right now.

[1]: http://labratrevenge.com/httpriot/docs/
