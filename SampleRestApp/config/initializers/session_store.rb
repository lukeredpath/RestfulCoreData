# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_SampleRestApp_session',
  :secret => '55a1f21c57352312fb8c062856ff139cdc1e5d69bb5b21f3ee467e5ec460b9aa09ab15ad2f10253ca9a68ad67c395d865997b97693c5f974a895f46f6f8cb3de'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
