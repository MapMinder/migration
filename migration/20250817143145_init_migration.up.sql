/* mapminderに必要なテーブルを作成 */

-- User table
CREATE TABLE user (
    user_id VARCHAR(40) PRIMARY KEY,
    username VARCHAR(60) NOT NULL,
    email VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- OAuth token table
CREATE TABLE oauth_token (
    oauth_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(40) NOT NULL,
    oauth_provider VARCHAR(50) NOT NULL,
    oauth_provider_id VARCHAR(255) NOT NULL,
    refresh_token TEXT,
    access_token_expiry DATETIME,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (oauth_provider, oauth_provider_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);

-- User settings table
CREATE TABLE user_setting (
    user_setting_id VARCHAR(40) PRIMARY KEY,
    user_id VARCHAR(40) NOT NULL,
    theme VARCHAR(10),
    language VARCHAR(3),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_setting_user FOREIGN KEY (user_id) REFERENCES user(user_id)
);

-- Reminder table
CREATE TABLE reminder (
    reminder_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(40) NOT NULL,
    note_id INT NULL,                        -- optional note
    location_id INT NOT NULL,                -- mandatory location
    reminder_flag BOOLEAN NOT NULL DEFAULT TRUE,
    date_time DATETIME NOT NULL,
    CONSTRAINT fk_reminder_user FOREIGN KEY (user_id) REFERENCES user(user_id)
);

-- Note table
CREATE TABLE note (
    note_id INT PRIMARY KEY AUTO_INCREMENT,
    reminder_id INT NULL,                     -- optional link to reminder
    title VARCHAR(255) NOT NULL,
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_note_reminder FOREIGN KEY (reminder_id) REFERENCES reminder(reminder_id)
);

-- Tag table
CREATE TABLE tag (
    tag_id INT PRIMARY KEY AUTO_INCREMENT,
    note_id INT NOT NULL,
    tag VARCHAR(20) NOT NULL,
    CONSTRAINT fk_tag_note FOREIGN KEY (note_id) REFERENCES note(note_id)
);

-- Location table
CREATE TABLE location (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    reminder_id INT NOT NULL,                 -- 1:1 with reminder
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    place_name VARCHAR(60),
    CONSTRAINT fk_location_reminder FOREIGN KEY (reminder_id) REFERENCES reminder(reminder_id)
);

-- Notification table (service-managed, no user input)
CREATE TABLE notification (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(40) NOT NULL,
    reminder_id INT NOT NULL,
    sent_at DATETIME,
    status VARCHAR(10),
    CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES user(user_id),
    CONSTRAINT fk_notification_reminder FOREIGN KEY (reminder_id) REFERENCES reminder(reminder_id)
);

-- Reminder recurrence table
CREATE TABLE reminder_recurrence (
    recurrence_id INT PRIMARY KEY AUTO_INCREMENT,
    reminder_id INT NOT NULL,
    recurrence_type VARCHAR(10) NOT NULL DEFAULT 'daily',   -- default recurrence
    CONSTRAINT fk_recurrences_reminder FOREIGN KEY (reminder_id) REFERENCES reminder(reminder_id)
);
