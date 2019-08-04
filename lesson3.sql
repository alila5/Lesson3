use shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '�������� �������',
  UNIQUE unique_name(name(10))
) COMMENT = '������� ��������-��������';

INSERT INTO catalogs VALUES
  (NULL, '����������'),
  (NULL, '����������� �����'),
  (NULL, '����������'),
  (NULL, '������� �����'),
  (NULL, '����������� ������');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��� ����������',
  birthday_at DATE COMMENT '���� ��������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '����������';

INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  ('��������', '1990-10-05', now()-interval floor(1000000*rand()) second, now()),
  ('�������', '1984-11-12',now()-interval floor(1000000*rand()) second, now()),
  ('���������', '1985-05-20', now()-interval floor(1000000*rand()) second, now()),
  ('������', '1988-02-14',now()-interval floor(1000000*rand()) second, now()),
  ('����', '1998-01-12',now()-interval floor(1000000*rand()) second, now()),
  ('�����', '1992-08-29',now()-interval floor(1000000*rand()) second, now());

DROP TABLE IF EXISTS users_error;
CREATE TABLE users_error (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��� ����������',
  birthday_at DATE COMMENT '���� ��������',
  created_at VARCHAR(255),
  updated_at VARCHAR(255) 
) COMMENT = '���������� �������� ������ ����';

INSERT INTO users_error (name, birthday_at, created_at, updated_at) VALUES
  ('��������', '1990-10-05', '20.10.2017 8:10',   '21.10.2018 8:11'),
  ('�������', '1984-11-12','20.10.2016 21:10',   '24.10.2018 18:17'),
  ('���������', '1985-05-20', '23.10.2017 18:10',   '23.10.2018 9:10');
 
ALTER TABLE users_error ADD created_at_new DATETIME;
ALTER TABLE users_error ADD updated_at_new DATETIME;
  
UPDATE  users_error  SET  created_at_new = str_to_date( created_at, '%d.%m.%Y %H:%i');
UPDATE  users_error  SET  updated_at_new = str_to_date( updated_at, '%d.%m.%Y %H:%i');

ALTER TABLE shop.storehouses_products drop foreign key  storehouses_products_fk2;

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��������',
  description TEXT COMMENT '��������',
  price DECIMAL (11,2) COMMENT '����',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = '�������� �������';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.', 7890.00, 1),
  ('Intel Core i5-7400', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.', 12700.00, 1),
  ('AMD FX-8320E', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� AMD.', 4780.00, 1),
  ('AMD FX-8320', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', '����������� ����� ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', '����������� ����� Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', '����������� ����� MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = '������';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT '���������� ���������� �������� �������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������ ������';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT '�������� ������ �� 0.0 �� 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = '������';

ALTER TABLE shop.storehouses_products drop foreign key  storehouses_products_fk;

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������';


INSERT INTO storehouses
	(name)
values
	('�����1'),
	('�����2');

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id BIGINT UNSIGNED,
  product_id BIGINT UNSIGNED,
  value INT UNSIGNED COMMENT '����� �������� ������� �� ������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������ �� ������';

ALTER TABLE shop.storehouses_products ADD CONSTRAINT storehouses_products_fk2 
FOREIGN KEY (product_id) REFERENCES shop.products(id) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE shop.storehouses_products ADD CONSTRAINT storehouses_products_fk 
FOREIGN KEY (storehouse_id) REFERENCES shop.storehouses(id) ON DELETE SET NULL ON UPDATE CASCADE;



INSERT INTO storehouses_products
	(storehouse_id, product_id, value)
values
	(1, 1, 100),
	(1, 2, 90),
	(1, 3, 2500),
	(1, 4, 0),
	(2, 5, 0);

SELECT * FROM storehouses_products ORDER BY case  when value=0 then '10000000' end, value asc  ;
-- ������� ��� �� ��������, �������� �� �������� ����  �����������

-- SELECT * from users where date_format(birthday_at, '%M') = 'august' or date_format(birthday_at, '%M') = 'may';
SELECT * from users where date_format(birthday_at, '%M') in ('may', 'august');

select * from catalogs where id in (5,1,2) order by case 
	when id =5 then '1'
	when id =1 then '2'
	when id =2 then '3'
end, 
id DESC;
-- ������� ��� �� ��������, �������� �� �������� ����  �����������



	