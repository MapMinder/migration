-- not going to make any google api calls other than the validity check 
-- so the columns not required
ALTER TABLE oauth_token DROP COLUMN refresh_token;
ALTER TABLE oauth_token DROP COLUMN access_token_expiry;
