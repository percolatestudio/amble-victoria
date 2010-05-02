# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_amble_session',
  :secret      => 'b55ed2f69b73d188e1e461fd543f2eb52e3eb63daf279ecd5a2a871a93c18fdb361493d7be814144f13a4688a969019544b59569225a845987e22aa73e6034a0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
