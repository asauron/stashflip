# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_beatmap_session',
  :secret      => '72a345b5870b3d24610cb4a4eaa11d90e05b97324c19be9e812003d41a9184dbb33df4c790ce8aaaa51db6280e05dfc29b5042f1bcf7e0e6d07213e8891efa65'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
