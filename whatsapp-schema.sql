-- Users table
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    username VARCHAR(50),
    profile_picture_url VARCHAR(255),
    status VARCHAR(100),
    last_seen TIMESTAMP
);

-- Chats table
CREATE TYPE chat_type AS ENUM ('individual', 'group');

CREATE TABLE Chats (
    chat_id SERIAL PRIMARY KEY,
    chat_type chat_type NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Chat Participants table (for both individual and group chats)
CREATE TABLE ChatParticipants (
    chat_id INTEGER,
    user_id INTEGER,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (chat_id, user_id),
    FOREIGN KEY (chat_id) REFERENCES Chats(chat_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Messages table
CREATE TABLE Messages (
    message_id SERIAL PRIMARY KEY,
    chat_id INTEGER,
    sender_id INTEGER,
    content TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_edited BOOLEAN DEFAULT FALSE,
    edit_timestamp TIMESTAMP,
    is_disappearing BOOLEAN DEFAULT FALSE,
    disappear_after INTEGER,
    FOREIGN KEY (chat_id) REFERENCES Chats(chat_id),
    FOREIGN KEY (sender_id) REFERENCES Users(user_id)
);

-- Media Attachments table
CREATE TYPE media_type AS ENUM ('image', 'video', 'audio', 'document');

CREATE TABLE MediaAttachments (
    attachment_id SERIAL PRIMARY KEY,
    message_id INTEGER,
    media_type media_type NOT NULL,
    file_url VARCHAR(255) NOT NULL,
    thumbnail_url VARCHAR(255),
    file_size INTEGER,
    FOREIGN KEY (message_id) REFERENCES Messages(message_id)
);

-- Message Edits History table
CREATE TABLE MessageEditsHistory (
    edit_id SERIAL PRIMARY KEY,
    message_id INTEGER,
    previous_content TEXT,
    edit_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (message_id) REFERENCES Messages(message_id)
);
