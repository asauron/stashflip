# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_stashflip_session',
  :secret      => 'f2b31677d8ad4ff80aaff6577232b627334f7d4622e31a32859312cf11807ab2f5bc10a37a853fcc36205121c87b3549bea75bb3be6e075811718a2fa969c259'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
