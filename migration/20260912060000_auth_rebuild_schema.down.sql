-- reverse of 20260912060000_auth_rebuild_schema.up.sql, in opposite order

ALTER TABLE user_setting DROP FOREIGN KEY fk_user_setting_user;
ALTER TABLE user_setting ADD CONSTRAINT fk_user_setting_user FOREIGN KEY (user_id) REFERENCES user(user_id);

ALTER TABLE reminder DROP FOREIGN KEY fk_reminder_user;
ALTER TABLE reminder ADD CONSTRAINT fk_reminder_user FOREIGN KEY (user_id) REFERENCES user(user_id);

DROP TABLE trigger_history;

ALTER TABLE user_setting ADD COLUMN language VARCHAR(3);
ALTER TABLE user_setting ADD COLUMN theme VARCHAR(10);

DROP TABLE authentication_code;
DROP TABLE account;

ALTER TABLE user ADD COLUMN email VARCHAR(255) NOT NULL DEFAULT '';

CREATE TABLE reminder_recurrence (
    recurrence_id INT PRIMARY KEY AUTO_INCREMENT,
    reminder_id VARCHAR(40) NOT NULL,
    recurrence_type VARCHAR(20) NOT NULL DEFAULT 'daily',
    CONSTRAINT fk_recurrence_reminder FOREIGN KEY (reminder_id) REFERENCES reminder(reminder_id)
);

CREATE TABLE tag (
    tag_id VARCHAR(40) PRIMARY KEY,
    reminder_id VARCHAR(40) NOT NULL,
    tag VARCHAR(20) NOT NULL,
    CONSTRAINT fk_tag_reminder FOREIGN KEY (reminder_id) REFERENCES reminder(reminder_id)
);

CREATE TABLE oauth_token (
    oauth_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(40) NOT NULL,
    oauth_provider VARCHAR(50) NOT NULL,
    oauth_provider_id VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (oauth_provider, oauth_provider_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);
