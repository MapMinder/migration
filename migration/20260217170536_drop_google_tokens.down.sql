ALTER TABLE oauth_tokens ADD COLUMN access_token_expiry DATETIME;
ALTER TABLE oauth_tokens ADD COLUMN refresh_token TEXT;
