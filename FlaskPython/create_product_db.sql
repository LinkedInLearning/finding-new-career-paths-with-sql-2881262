CREATE TABLE category (
	category_id INTEGER, 
	category_name TEXT, 
	PRIMARY KEY (category_id)
);

CREATE TABLE product (
	product_id INTEGER, 
	product_name TEXT, 
	product_description TEXT, 
	price TEXT, 
	category_id INTEGER, 
	PRIMARY KEY (product_id), 
	FOREIGN KEY (category_id) REFERENCES category (category_id)
);