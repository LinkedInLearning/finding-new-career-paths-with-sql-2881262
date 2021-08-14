create table customers (
CustomerID INT NOT NULL,
FirstName VARCHAR(255),
LastName VARCHAR(255),
Email VARCHAR(255),
Phone VARCHAR(255),
Address VARCHAR(255),
City VARCHAR(255),
State VARCHAR(255),
Zipcode VARCHAR(255),
PRIMARY KEY(CustomerID)
);

create table census_state_pop (
statename VARCHAR(255),
pop VARCHAR(255),
code VARCHAR(255)
);