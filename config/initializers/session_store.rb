# Be sure to restart your server when you modify this file.

# Vad::Application.config.session_store :cookie_store, key: '_vad_session'
Vad::Application.config.session_store :redis_store, :namespace => "vad:#{Rails.env}:session",
  :key => "_vad_#{Rails.env}_session"

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Vad::Application.config.session_store :active_record_store
