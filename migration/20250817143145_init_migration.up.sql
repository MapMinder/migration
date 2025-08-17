/* mapminderに必要なテーブルを作成 */

-- Users table
CREATE TABLE users (
    user_id VARCHAR(40) PRIMARY KEY,
    username VARCHAR(60),
    email VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- OAuth tokens table
CREATE TABLE oauth_tokens (
    oauth_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(40),
    oauth_provider VARCHAR(50),
    oauth_provider_id VARCHAR(255),
    refresh_token TEXT,
    access_token_expiry TIMESTAMP,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_oauth_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- User settings table
CREATE TABLE user_setting (
    user_setting_id VARCHAR(40) PRIMARY KEY,
    user_id VARCHAR(40),
    theme VARCHAR(10),
    language VARCHAR(3),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_setting_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Reminders table
CREATE TABLE reminders (
    reminder_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(40),
    note_id INT,
    location_id INT,
    reminder_flag BOOLEAN,
    date_time DATETIME,
    CONSTRAINT fk_reminders_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Notes table
CREATE TABLE notes (
    note_id INT PRIMARY KEY AUTO_INCREMENT,
    reminder_id INT,
    title VARCHAR(255),
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_notes_reminder FOREIGN KEY (reminder_id) REFERENCES reminders(reminder_id)
);

-- Tags table
CREATE TABLE tags (
    tag_id INT PRIMARY KEY AUTO_INCREMENT,
    note_id INT,
    tag VARCHAR(20),
    CONSTRAINT fk_tags_note FOREIGN KEY (note_id) REFERENCES notes(note_id)
);

-- Locations table
CREATE TABLE locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    reminder_id INT,
    latitude FLOAT,
    longitude FLOAT,
    place_name VARCHAR(60),
    CONSTRAINT fk_locations_reminder FOREIGN KEY (reminder_id) REFERENCES reminders(reminder_id)
);

-- Notifications table
CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(40),
    reminder_id INT,
    sent_at DATETIME,
    status VARCHAR(10),
    CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_notifications_reminder FOREIGN KEY (reminder_id) REFERENCES reminders(reminder_id)
);

-- Reminder recurrences table
CREATE TABLE reminder_recurrences (
    recurrence_id INT PRIMARY KEY AUTO_INCREMENT,
    reminder_id INT,
    recurrence_type VARCHAR(10),
    CONSTRAINT fk_recurrences_reminder FOREIGN KEY (reminder_id) REFERENCES reminders(reminder_id)
);
