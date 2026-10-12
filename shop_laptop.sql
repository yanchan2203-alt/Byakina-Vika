CREATE TABLE manufacturers (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE categories (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE models (
    id              SERIAL PRIMARY KEY,
    manufacturer_id INT NOT NULL REFERENCES manufacturers(id),
    category_id     INT NOT NULL REFERENCES categories(id),
    name            VARCHAR(200) NOT NULL,
    image_path      VARCHAR(255),
    description     TEXT,
    base_price      DECIMAL(10,2) NOT NULL CHECK (base_price >= 0)
);

CREATE TABLE configurations (
    id              SERIAL PRIMARY KEY,
    model_id        INT NOT NULL REFERENCES models(id) ON DELETE CASCADE,
    ram             VARCHAR(50) NOT NULL,
    storage         VARCHAR(50) NOT NULL,
    stock_quantity  INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    UNIQUE (model_id, ram, storage)
);

CREATE TABLE users (
    id         SERIAL PRIMARY KEY,
    full_name  VARCHAR(200) NOT NULL,
    login      VARCHAR(50) UNIQUE NOT NULL,
    role       VARCHAR(20) NOT NULL CHECK (role IN ('customer','manager','admin'))
);

CREATE TABLE orders (
    id          SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES users(id),
    order_date  DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE order_items (
    id                SERIAL PRIMARY KEY,
    order_id          INT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    configuration_id  INT NOT NULL REFERENCES configurations(id),
    quantity          INT NOT NULL CHECK (quantity > 0)
);

-- Данные
INSERT INTO manufacturers (name) VALUES
('ASUS'),('Lenovo'),('HP'),('Dell'),('Acer'),('MSI'),('Apple');

INSERT INTO categories (name) VALUES
('Игровые'),('Офисные'),('Ультрабуки'),('Рабочие станции');

INSERT INTO models (manufacturer_id, category_id, name, image_path, description, base_price) VALUES
(1,1,'ROG Strix G15',  'images/picture.png','Игровой ноутбук',       120000.00),
(2,2,'IdeaPad 3',      'images/picture.png','Офисный ноутбук',        55000.00),
(3,3,'Spectre x360',   'images/picture.png','Премиальный ультрабук', 150000.00),
(4,4,'Precision 3560', 'images/picture.png','Рабочая станция',       180000.00),
(5,2,'Aspire 5',       'images/picture.png','Универсальный ноутбук',  60000.00),
(6,1,'Katana GF66',    'images/picture.png','Игровой ноутбук',        95000.00),
(7,3,'MacBook Air M2', 'images/picture.png','Ультрабук',             130000.00);

INSERT INTO configurations (model_id, ram, storage, stock_quantity) VALUES
(1,'16GB','512GB', 5),
(1,'32GB','1TB',   2),
(2,'8GB','256GB', 10),
(2,'16GB','512GB', 8),
(3,'16GB','1TB',   3),
(4,'32GB','1TB',   1),
(4,'64GB','2TB',   2),
(5,'8GB','512GB', 15),
(5,'16GB','512GB',12),
(6,'16GB','512GB', 6),
(6,'16GB','1TB',   4),
(7,'8GB','256GB', 20),
(7,'16GB','512GB',10);

INSERT INTO users (full_name, login, role) VALUES
('Иванов Иван Иванович',    'ivanov',  'customer'),
('Петров Пётр Петрович',    'petrov',  'manager'),
('Сидоров Сидор Сидорович', 'sidorov', 'admin');

INSERT INTO orders (customer_id, order_date) VALUES
(1, CURRENT_DATE - INTERVAL '1 month'),
(1, CURRENT_DATE - INTERVAL '15 days');

INSERT INTO order_items (order_id, configuration_id, quantity) VALUES
(1, 3, 1),
(2,12, 2);