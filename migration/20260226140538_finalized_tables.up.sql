-- tables to drop
ALTER TABLE tag DROP FOREIGN KEY fk_tag_note;
ALTER TABLE tag DROP COLUMN note_id;
ALTER TABLE tag ADD COLUMN reminder_id VARCHAR(40) NOT NULL;
ALTER TABLE tag ADD CONSTRAINT fk_tag_reminder FOREIGN KEY (reminder_id) REFERENCES reminder(reminder_id);
ALTER TABLE reminder DROP COLUMN note_id;
ALTER TABLE reminder DROP COLUMN location_id;
ALTER TABLE reminder ADD COLUMN longitude DECIMAL(9,6) NOT NULL;
ALTER TABLE reminder ADD COLUMN latitude DECIMAL(9,6) NOT NULL;
ALTER TABLE reminder ADD COLUMN radius DECIMAL(10,2) NOT NULL;
ALTER TABLE reminder ADD COLUMN status VARCHAR(20) NOT NULL;
ALTER TABLE reminder ADD COLUMN last_triggered_at DATETIME;
ALTER TABLE reminder ADD COLUMN completed_at DATETIME;
ALTER TABLE reminder ADD COLUMN description text NOT NULL;
ALTER TABLE reminder ADD COLUMN title VARCHAR(20) NOT NULL;
DROP TABLE notification;
DROP TABLE note;
DROP TABLE location;
