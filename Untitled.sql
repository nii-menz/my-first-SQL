# Centers and Rooms
CREATE TABLE center (
    center_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique  identifier for each center
    name VARCHAR(100) NOT NULL UNIQUE, -- Unique name for each center
    address VARCHAR(255) NOT NULL  -- Address of the center
);

CREATE TABLE Room(
    room_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each room
    room_number INT  NOT NULL,   -- Number within a center
    capacity INT NOT NULL,  -- Capacity of the room
    center_id INT NOT NULL,    -- Links the room to its center
    UNIQUE(room_number, center_id), -- -- Ensure room numbers are unique within a center
    FOREIGN KEY (center_id) REFERENCES center(center_id)  -- Foreigh key linking room to center
);

# Persons and Trainers

CREATE TABLE Person ( 
    person_id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
	birth_date DATE NOT NULL,
    UNIQUE(first_name, last_name, birth_date) -- Ensure uniqueness across name and birth date 
);

CREATE TABLE Trainer (
    trainer_id INT PRIMARY KEY, -- Same ID as person
    diploma VARCHAR(255) NOT NULL,
    FOREIGN KEY (trainer_id) REFERENCES Person(person_id) -- links Trainer to person
    );
    
    #Sessions
    
CREATE TABLE Session (
	session_id INT AUTO_INCREMENT PRIMARY KEY,
    session_date DATE NOT NULL,
    start_hour TIME NOT NULL,
    session_type VARCHAR(50), -- type of session only(NULL for individual)
    room_id INT NOT NULL,
    trainer_id INT, -- NULL for individual sessions
    FOREIGN KEY (room_id) REFERENCES Room(room_id),  -- Room for the session
    FOREIGN KEY (trainer_id) REFERENCES Trainer(trainer_id) -- Trainer for group sessions
);

#Registration (Participants and Supervision)

CREATE TABLE Participant(
	participant_id INT NOT NULL,
    session_id INT NOT NULL,
    PRIMARY KEY (participant_id, session_id), -- composite key for participant and session
    FOREIGN KEY (participant_id) REFERENCES Persons(person_id), -- links to person
    FOREIGN KEY(session_id) REFERENCES Session(session_id)  -- links to session
);

# Add Constraints

ALTER TABLE Session
ADD CONSTRAINT unique_session_in_room
UNIQUE (session_date, start_hour, room_id);


# Add Persons and Trainers


INSERT INTO Person (first_name, last_name, birth_date)
 VALUES('REXFORD', 'MENSAH', '1990-08-04');
INSERT INTO Trainer(trainer_id, diploma) 
VALUES (1, 'Certified Personal Trainer');

#Add session

INSERT INTO Session (session_date, start_hour,session_type, room_id, trainer_id)
VALUES('2025-02-01', '10:00:00', 'Aerobics', 1,1);
INSERT INTO Session(session_date, start_hour,room_id) 
VALUES ('2025-02-01', '11:00:00', 2); -- Individual session


# Register Participants
INSERT INTO Participant (participants_id, session_id) 
VALUES (1,1);

# QUERY EXAMPLE - Get sessions in a specific center

SELECT s.session_id, s.session_date, s.start_hour, s.session_type, r.room_number
FROM Session s
JOIN Room r ON s.room_id = r.room_id
JOIN Center c ON r.center_id = c.center_id
WHERE c.name = 'Fitplaza';

#Get all participants of a session:

SELECT p.first_name, p.last_name
FROM Participant pa
JOIN Person p ON pa.participant_id = p.person_id
WHERE  pa.session_id = 1;












