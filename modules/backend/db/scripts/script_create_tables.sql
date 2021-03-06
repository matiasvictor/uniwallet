# Script de criação do banco de dados.

DROP DATABASE IF EXISTS Uniwallet;
CREATE DATABASE Uniwallet;

USE Uniwallet;
CREATE TABLE Users (
	id INT(32) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(64) NOT NULL,
	email VARCHAR(64) NOT NULL,
	password VARCHAR(128) NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE AccessLevels (
	id INT(32) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(32) NOT NULL,
	description VARCHAR(256),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Users (name, email, password) VALUES
('Uniwallet', 'team@team.com', '2aa6a66ca99c48666d8dc1eb2280e28be941a607053b3ddadb596b2d49f53532');

INSERT INTO AccessLevels (name, description) VALUES
('registered', 'Basic access level for everyone logged by default'),
('consumer', 'Consumer access level'),
('company', 'Company access level'),
('god', 'Unlimited access');

CREATE TABLE User_AccessLevel (
	id INT(32) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	user_id INT(32) UNSIGNED NOT NULL,
	accesslevel_id INT(32) UNSIGNED NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES Users(id),
	FOREIGN KEY (accesslevel_id) REFERENCES AccessLevels(id)
);

INSERT INTO User_AccessLevel (user_id, accesslevel_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4);


CREATE TABLE AuthSession (
	id INT(32) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	user_id INT(32) UNSIGNED NOT NULL,
	token VARCHAR(256) NOT NULL,
	ip VARCHAR(128) NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES Users(id)
);

CREATE TABLE Universities (
	id INT(32) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(32) NOT NULL,
	abbreviation VARCHAR(32) NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Universities (name, abbreviation) VALUES
('Universidade de Brasília', 'UnB'),
('Universidade de São Paulo', 'USP');

CREATE TABLE Consumers (
	id INT(32) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	user_id INT(32) UNSIGNED NOT NULL,
	fullname VARCHAR(128) NOT NULL,
	university_id INT(32) UNSIGNED NOT NULL,
	cpf VARCHAR(64) NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (university_id) REFERENCES Universities(id)
);

CREATE TABLE Companies (
	id INT(32) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	user_id INT(32) UNSIGNED NOT NULL,
	name VARCHAR(128) NOT NULL,
	cnpj VARCHAR(32),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES Users(id)
);

INSERT INTO Consumers (user_id, fullname, university_id, cpf) VALUES
('1', 'Uniwallet', 1, '68535997725');

INSERT INTO Companies (user_id, name, cnpj) VALUES
('1', 'Uniwallet', '68535997725');

CREATE TABLE Wallets (
	id INT(32) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	user_id INT(32) UNSIGNED NOT NULL,
	balance DOUBLE UNSIGNED NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES Users(id)
);

INSERT INTO Wallets (user_id, balance) VALUES
('1', '1000');

INSERT INTO Stores (name, company_id) VALUES
('Uni_store', '1');

CREATE TABLE Categories (
	id INT(32) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(128) NOT NULL,
	description VARCHAR(128) NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Products (
	id INT(32) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	company_id INT(32) UNSIGNED NOT NULL,
	name VARCHAR(128) NOT NULL,
	description VARCHAR(256) NOT NULL,
	price DOUBLE UNSIGNED NOT NULL,
	quantity INT(32) NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	available BIT(1) DEFAULT 1 NOT NULL,
	FOREIGN KEY (company_id) REFERENCES Companies(id)
);

INSERT INTO Products (company_id, name, description, price, quantity) VALUES
('1', 'salada', 'Refeicao', 300, 10);

INSERT INTO Products (company_id, name, description, price, quantity) VALUES
('1', 'cheese burguer', 'Refeicao', 500, 8);

CREATE TABLE Product_Category (
	id INT(32) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	product_id INT(32) UNSIGNED NOT NULL,
	category_id INT(32) UNSIGNED NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (product_id) REFERENCES Products(id),
	FOREIGN KEY (category_id) REFERENCES Categories(id)
);

CREATE TABLE Product_Prices (
	id INT(32) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	product_id INT(32) UNSIGNED NOT NULL,
	price DOUBLE UNSIGNED NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (product_id) REFERENCES Products(id)
);

INSERT INTO Product_Prices (product_id, price) VALUES
('1', '65.50');

CREATE TABLE Transactions (
	id INT(32) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	wallet_from INT(32) UNSIGNED NOT NULL,
	wallet_to INT(32) UNSIGNED NOT NULL,
	value DOUBLE UNSIGNED NOT NULL,
	operation VARCHAR(256) NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (wallet_from) REFERENCES Wallets(id),
	FOREIGN KEY (wallet_to) REFERENCES Wallets(id)
);

CREATE TABLE Purchases (
	id INT(32) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	transaction_id INT(32) UNSIGNED NOT NULL,
	consumer_id INT(32) UNSIGNED NOT NULL,
	company_id INT(32) UNSIGNED NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (transaction_id) REFERENCES Transactions(id),
	FOREIGN KEY (consumer_id) REFERENCES Consumers(id),
	FOREIGN KEY (company_id) REFERENCES Companies(id)
);

CREATE TABLE Purchase_Product (
	id INT(32) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	purchase_id INT(32) UNSIGNED NOT NULL,
	product_id INT(32) UNSIGNED NOT NULL,
	quantity INT(128) UNSIGNED NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (purchase_id) REFERENCES Purchases(id),
	FOREIGN KEY (product_id) REFERENCES Products(id)
);
