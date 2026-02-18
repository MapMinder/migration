ALTER TABLE oauth_token ADD COLUMN access_token_expiry DATETIME;
ALTER TABLE oauth_token ADD COLUMN refresh_token TEXT;
