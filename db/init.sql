CREATE TABLE IF NOT EXISTS persons (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT,
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT
);

INSERT INTO persons (name, age, email, phone, address) VALUES
('John Doe', 30, 'john.doe@example.com', '555-0100', '123 Main St, Anytown'),
('Jane Smith', 28, 'jane.smith@example.com', '555-0101', '456 Oak St, Othertown'),
('Michael Johnson', 45, 'michael.j@example.com', '555-0102', '789 Pine Rd, Sometown'),
('Emily Davis', 32, 'emily.d@example.com', '555-0103', '321 Elm St, Anytown'),
('David Wilson', 50, 'david.w@example.com', '555-0104', '654 Maple Ave, Villagetown'),
('Sarah Brown', 25, 'sarah.b@example.com', '555-0105', '987 Cedar Ln, Cityburg'),
('Robert Jones', 40, 'robert.j@example.com', '555-0106', '147 Birch Blvd, Townsville'),
('Lisa Garcia', 35, 'lisa.g@example.com', '555-0107', '258 Spruce Ct, Hamlet'),
('William Martinez', 29, 'william.m@example.com', '555-0108', '369 Ash Dr, Metropolis'),
('Mary Anderson', 42, 'mary.a@example.com', '555-0109', '741 Walnut Way, Megacity');
