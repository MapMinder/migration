CREATE TABLE notification (
    notification_id VARCHAR(40) PRIMARY KEY,
    user_id VARCHAR(40) NOT NULL,
    reminder_id VARCHAR(40) NOT NULL,
    last_triggered_at DATETIME,
    is_active BOOLEAN,
    CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES user(user_id),
    CONSTRAINT fk_notification_reminder FOREIGN KEY (reminder_id) REFERENCES reminder(reminder_id)
);


CREATE TABLE note (
    note_id VARCHAR(40) PRIMARY KEY,
    reminder_id VARCHAR(40) NOT NULL,            -- optional link to reminder
    title VARCHAR(255) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_note_reminder FOREIGN KEY (reminder_id) REFERENCES reminder(reminder_id)
);

CREATE TABLE location (
    location_id VARCHAR(40) PRIMARY KEY,
    reminder_id VARCHAR(40) NOT NULL,        -- 1:1 with reminder
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    radius DECIMAL(10,2) NOT NULL,           -- geofencing radius in meters
    CONSTRAINT fk_location_reminder FOREIGN KEY (reminder_id) REFERENCES reminder(reminder_id)
);

ALTER TABLE tag DROP FOREIGN KEY fk_tag_reminder;
ALTER TABLE tag DROP COLUMN reminder_id;
ALTER TABLE tag ADD COLUMN note_id VARCHAR(40) NOT NULL;
ALTER TABLE tag ADD CONSTRAINT fk_tag_note FOREIGN KEY (note_id) REFERENCES note(note_id);
ALTER TABLE reminder DROP COLUMN longitude;
ALTER TABLE reminder DROP COLUMN latitude;
ALTER TABLE reminder DROP COLUMN radius;
ALTER TABLE reminder DROP COLUMN status;
ALTER TABLE reminder DROP COLUMN last_triggered_at;
ALTER TABLE reminder DROP COLUMN completed_at;
ALTER TABLE reminder DROP COLUMN title;
ALTER TABLE reminder DROP description;
ALTER TABLE reminder ADD COLUMN note_id VARCHAR(40);
ALTER TABLE reminder ADD COLUMN location_id VARCHAR(40);
