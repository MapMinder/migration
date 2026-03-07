/* mapminderに必要なテーブルを作成 */

-- Users table
CREATE TABLE user (
    user_id VARCHAR(40) PRIMARY KEY,
    username VARCHAR(60) NOT NULL,
    email VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- OAuth tokens table
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

-- Reminders table
CREATE TABLE reminder (
    reminder_id VARCHAR(40) PRIMARY KEY,
    user_id VARCHAR(40) NOT NULL,
    note_id VARCHAR(40) NOT NULL,                
    location_id VARCHAR(40) NOT NULL,           
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_reminder_user FOREIGN KEY (user_id) REFERENCES user(user_id)
);

-- Notes table
CREATE TABLE note (
    note_id VARCHAR(40) PRIMARY KEY,
    reminder_id VARCHAR(40) NOT NULL,            -- optional link to reminder
    title VARCHAR(255) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_note_reminder FOREIGN KEY (reminder_id) REFERENCES reminder(reminder_id)
);

-- Tags table
CREATE TABLE tag (
    tag_id VARCHAR(40) PRIMARY KEY,
    note_id VARCHAR(40) NOT NULL,
    tag VARCHAR(20) NOT NULL,
    CONSTRAINT fk_tag_note FOREIGN KEY (note_id) REFERENCES note(note_id)
);

-- Locations table
CREATE TABLE location (
    location_id VARCHAR(40) PRIMARY KEY,
    reminder_id VARCHAR(40) NOT NULL,        -- 1:1 with reminder
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    radius DECIMAL(10,2) NOT NULL,           -- geofencing radius in meters
    CONSTRAINT fk_location_reminder FOREIGN KEY (reminder_id) REFERENCES reminder(reminder_id)
);

-- Notifications table (service-managed, no user input)
CREATE TABLE notification (
    notification_id VARCHAR(40) PRIMARY KEY,
    user_id VARCHAR(40) NOT NULL,
    reminder_id VARCHAR(40) NOT NULL,
    last_triggered_at DATETIME,
    is_active BOOLEAN,
    CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES user(user_id),
    CONSTRAINT fk_notification_reminder FOREIGN KEY (reminder_id) REFERENCES reminder(reminder_id)
);

-- Reminder recurrences table
CREATE TABLE reminder_recurrence (
    recurrence_id VARCHAR(40) PRIMARY KEY,
    reminder_id VARCHAR(40) NOT NULL,
    recurrence_type VARCHAR(10) NOT NULL DEFAULT 'daily',
    CONSTRAINT fk_recurrence_reminder FOREIGN KEY (reminder_id) REFERENCES reminder(reminder_id)
);
