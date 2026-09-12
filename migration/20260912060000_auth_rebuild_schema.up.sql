-- MAP-100: schema redesign for first-party email + password auth
-- Replaces oauth_token with account + authentication_code, drops the unused
-- tag / reminder_recurrence tables, strips user_setting down to a bare
-- placeholder, and adds trigger_history for debugging geofence events.

-- oauth_token is dead now that Google Sign-In is being removed
DROP TABLE oauth_token;

-- unused, no code ever built against them
DROP TABLE tag;
DROP TABLE reminder_recurrence;

-- email moves from user to account
ALTER TABLE user DROP COLUMN email;

CREATE TABLE account (
    account_id VARCHAR(40) PRIMARY KEY,
    user_id VARCHAR(40) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    verified BOOLEAN NOT NULL DEFAULT FALSE,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (user_id),
    UNIQUE (email),
    CONSTRAINT fk_account_user FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);

-- holds both signup verification codes and password-reset codes, keyed by type.
-- a row per code issued (not one row reused) so resend never races a delete.
CREATE TABLE authentication_code (
    authentication_code_id VARCHAR(40) PRIMARY KEY,
    account_id VARCHAR(40) NOT NULL,
    authentication_code VARCHAR(255) NOT NULL,
    attempts INT NOT NULL DEFAULT 0,
    type VARCHAR(20) NOT NULL,
    expires_at DATETIME NOT NULL,
    consumed_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_authentication_code_account FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE
);

-- no setting exists yet; kept as a placeholder for whatever lands first
ALTER TABLE user_setting DROP COLUMN theme;
ALTER TABLE user_setting DROP COLUMN language;

-- append-only log of every geofence trigger evaluation, so "why didn't this
-- notify me" is a row lookup instead of a guess
CREATE TABLE trigger_history (
    trigger_history_id VARCHAR(40) PRIMARY KEY,
    reminder_id VARCHAR(40) NOT NULL,
    notified BOOLEAN NOT NULL,
    skip_reason VARCHAR(30),
    triggered_at DATETIME NOT NULL,
    CONSTRAINT fk_trigger_history_reminder FOREIGN KEY (reminder_id) REFERENCES reminder(reminder_id) ON DELETE CASCADE
);

-- account deletion (MAP-105) needs a single DELETE FROM user to clean up
-- everything belonging to that user; these two FKs predate this migration
-- and were never cascading
ALTER TABLE reminder DROP FOREIGN KEY fk_reminder_user;
ALTER TABLE reminder ADD CONSTRAINT fk_reminder_user FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE;

ALTER TABLE user_setting DROP FOREIGN KEY fk_user_setting_user;
ALTER TABLE user_setting ADD CONSTRAINT fk_user_setting_user FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE;
