DROP TABLE IF EXISTS orderFoodLink;
DROP TABLE IF EXISTS food;
DROP TABLE IF EXISTS "order";
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS address;


-- USER Admin's accounts password == "admin" User's accounts password == "user"
CREATE TABLE user (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT (datetime('now','localtime')),
  role TEXT CHECK(role IN ('user','admin')) NOT NULL DEFAULT 'user',
  google_id TEXT UNIQUE
);

CREATE TABLE "order" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  price INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  is_done TEXT CHECK(is_done IN ('true','false','cancel')) NOT NULL DEFAULT 'false',
  making_time INTEGER NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT (datetime('now','localtime')),
  address_id INTEGER not null,
  FOREIGN KEY (user_id) REFERENCES user (id),
  FOREIGN KEY (address_id) REFERENCES address (id)
);

CREATE TABLE address (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  city TEXT NOT NULL,
  street TEXT NOT NULL,
  postal_code TEXT not null
);

CREATE TABLE orderFoodLink (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  order_id INTEGER NOT NULL,
  food_id INTEGER NOT NULL,
  FOREIGN KEY (order_id) REFERENCES "order" (id),
  FOREIGN KEY (food_id) REFERENCES food (id)
);

CREATE TABLE food (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  ingredients TEXT NOT NULL,
  price INTEGER NOT NULL,
  category TEXT CHECK(category IN ('pizza','burger', 'ostatní')) NOT NULL,
  is_public TEXT CHECK(is_public IN ('true','false')) NOT NULL DEFAULT 'false'
);


-- FILL DATABASE WITH TEST DATA --

-- USER MOCK Admin's password == "admin" User's password == "user"
INSERT INTO user (id, name, email, password, role) VALUES (1, 'Jan Novotný', 'admin1@admin.cz', 'pbkdf2:sha256:260000$CkJbESyAEuSRRnS9$81ae69ef284baf363ee094a77351248f74544816f0d99786414e2eeed40d1f5a', 'admin');
INSERT INTO user (id, name, email, password, role) VALUES (2, 'Lenka Zelená', 'admin2@admin.cz', 'pbkdf2:sha256:260000$CkJbESyAEuSRRnS9$81ae69ef284baf363ee094a77351248f74544816f0d99786414e2eeed40d1f5a', 'admin');

INSERT INTO user (id, name, email, password, role) VALUES (3, 'Pavel Svoboda', 'user1@user.cz', 'pbkdf2:sha256:260000$ZqZMQdWoEnmncjBj$db6a3919ba83993c69f496fae023619593646ec47590195872c00a41547c5273', 'user');
INSERT INTO user (id, name, email, password, role) VALUES (4, 'Barbora Dvořáková', 'user2@user.cz', 'pbkdf2:sha256:260000$ZqZMQdWoEnmncjBj$db6a3919ba83993c69f496fae023619593646ec47590195872c00a41547c5273', 'user');
INSERT INTO user (id, name, email, password, role) VALUES (5, 'Kristýna Kopecká', 'user3@user.cz', 'pbkdf2:sha256:260000$ZqZMQdWoEnmncjBj$db6a3919ba83993c69f496fae023619593646ec47590195872c00a41547c5273', 'user');
INSERT INTO user (id, name, email, password, role) VALUES (6, 'Patrik Sedláček', 'user4@user.cz', 'pbkdf2:sha256:260000$ZqZMQdWoEnmncjBj$db6a3919ba83993c69f496fae023619593646ec47590195872c00a41547c5273', 'user');


-- ADDRESS MOCK
insert into address (id, city, street, postal_code) values (1, 'Praha', '25798 Meadow Ridge Parkway', '19770');
insert into address (id, city, street, postal_code) values (2, 'Praha', '4589 Becker Point', '12400');
insert into address (id, city, street, postal_code) values (3, 'Praha', '85947 Northwestern Place', '10560');
insert into address (id, city, street, postal_code) values (4, 'Praha', '3574 Meadow Ridge Hill', '17810');
insert into address (id, city, street, postal_code) values (5, 'Praha', '08589 Green Court', '18470');
insert into address (id, city, street, postal_code) values (6, 'Praha', '027 Bartelt Point', '10550');
insert into address (id, city, street, postal_code) values (7, 'Praha', '629 Arapahoe Center', '16670');
insert into address (id, city, street, postal_code) values (8, 'Praha', '6131 Northfield Point', '17710');
insert into address (id, city, street, postal_code) values (9, 'Praha', '5764 Spaight Circle', '12550');
insert into address (id, city, street, postal_code) values (10, 'Praha', '90 Acker Court', '18350');
insert into address (id, city, street, postal_code) values (11, 'Praha', '24 Hovde Center', '11710');
insert into address (id, city, street, postal_code) values (12, 'Praha', '039 Artisan Hill', '14360');
insert into address (id, city, street, postal_code) values (13, 'Praha', '42110 Debs Alley', '10170');
insert into address (id, city, street, postal_code) values (14, 'Praha', '51 Helena Parkway', '11740');
insert into address (id, city, street, postal_code) values (15, 'Praha', '936 Transport Alley', '18700');
insert into address (id, city, street, postal_code) values (16, 'Praha', '95 Heffernan Parkway', '17150');
insert into address (id, city, street, postal_code) values (17, 'Praha', '66546 Butterfield Drive', '11850');
insert into address (id, city, street, postal_code) values (18, 'Praha', '266 Delaware Parkway', '11060');
insert into address (id, city, street, postal_code) values (19, 'Praha', '0052 Badeau Place', '19290');
insert into address (id, city, street, postal_code) values (20, 'Praha', '553 Mccormick Court', '10940');
insert into address (id, city, street, postal_code) values (21, 'Praha', '74350 Dennis Hill', '16800');
insert into address (id, city, street, postal_code) values (22, 'Praha', '57 Fallview Street', '18330');
insert into address (id, city, street, postal_code) values (23, 'Praha', '174 Carioca Trail', '10790');
insert into address (id, city, street, postal_code) values (24, 'Praha', '918 Bayside Way', '15610');
insert into address (id, city, street, postal_code) values (25, 'Praha', '60 Scott Lane', '19640');
insert into address (id, city, street, postal_code) values (26, 'Praha', '0449 Schmedeman Pass', '16660');
insert into address (id, city, street, postal_code) values (27, 'Praha', '646 Marcy Crossing', '13920');
insert into address (id, city, street, postal_code) values (28, 'Praha', '2 Farragut Circle', '16830');
insert into address (id, city, street, postal_code) values (29, 'Praha', '6551 Fisk Junction', '11990');
insert into address (id, city, street, postal_code) values (30, 'Praha', '80668 Utah Way', '15900');
insert into address (id, city, street, postal_code) values (31, 'Praha', '077 Brown Parkway', '12260');
insert into address (id, city, street, postal_code) values (32, 'Praha', '27643 Brickson Park Junction', '15350');
insert into address (id, city, street, postal_code) values (33, 'Praha', '1487 Del Sol Junction', '14020');
insert into address (id, city, street, postal_code) values (34, 'Praha', '277 Petterle Center', '14520');
insert into address (id, city, street, postal_code) values (35, 'Praha', '9611 Rusk Crossing', '13500');
insert into address (id, city, street, postal_code) values (36, 'Praha', '12 Old Shore Court', '15670');
insert into address (id, city, street, postal_code) values (37, 'Praha', '2741 Anderson Alley', '16930');
insert into address (id, city, street, postal_code) values (38, 'Praha', '29 Sherman Place', '12990');
insert into address (id, city, street, postal_code) values (39, 'Praha', '56 Pleasure Junction', '10460');
insert into address (id, city, street, postal_code) values (40, 'Praha', '9 Dunning Circle', '12960');
insert into address (id, city, street, postal_code) values (41, 'Praha', '0879 Manitowish Terrace', '16040');
insert into address (id, city, street, postal_code) values (42, 'Praha', '162 Sunfield Street', '16100');
insert into address (id, city, street, postal_code) values (43, 'Praha', '734 Nancy Trail', '13300');
insert into address (id, city, street, postal_code) values (44, 'Praha', '4 Manufacturers Terrace', '12410');
insert into address (id, city, street, postal_code) values (45, 'Praha', '8 Esch Circle', '19530');
insert into address (id, city, street, postal_code) values (46, 'Praha', '4310 Rieder Center', '14710');
insert into address (id, city, street, postal_code) values (47, 'Praha', '27 Pond Lane', '14440');
insert into address (id, city, street, postal_code) values (48, 'Praha', '5161 La Follette Way', '18350');
insert into address (id, city, street, postal_code) values (49, 'Praha', '62742 Fulton Park', '10050');
insert into address (id, city, street, postal_code) values (50, 'Praha', '55 Hanover Way', '10760');
insert into address (id, city, street, postal_code) values (51, 'Praha', 'V Záhoří 158', '15800');


-- ORDER MOCK
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (1, 1039, 'true', 4, 40, 20);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (2, 1105, 'true', 5, 37, 20);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (3, 463, 'true', 5, 24, 20);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (4, 428, 'true', 4, 8, 20);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (5, 267, 'true', 4, 8, 20);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (6, 299, 'true', 3, 18, 20);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (7, 1123, 'true', 3, 14, 25);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (8, 1265, 'true', 4, 23, 25);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (9, 667, 'true', 3, 42, 25);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (10, 1482, 'true', 6, 15, 25);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (11, 1197, 'true', 3, 23, 25);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (12, 1096, 'true', 3, 2, 25);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (13, 1285, 'true', 3, 27, 25);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (14, 277, 'true', 5, 9, 25);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (15, 1394, 'true', 6, 48, 25);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (16, 313, 'true', 4, 15, 20);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (17, 451, 'true', 4, 31, 30);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (18, 912, 'true', 4, 34, 30);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (19, 645, 'true', 6, 12, 30);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (20, 1133, 'true', 3, 9, 30);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (21, 352, 'true', 6, 36, 30);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (22, 1498, 'true', 6, 2, 30);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (23, 620, 'true', 6, 3, 35);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (24, 1031, 'true', 4, 21, 35);
insert into "order" (id, price, is_done, user_id, address_id, making_time) values (25, 464, 'true', 3, 16, 35);


-- FOOD MOCK
insert into food (id, title, ingredients, price, category, is_public) values (1, 'Margherita', 'bazalka,mozzarella,rajčatové sugo', 149, 'pizza', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (2, 'Prosciutto', 'bazalka,mozzarella,rajčatové sugo,šunka', 169, 'pizza', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (3, 'Salami', 'bazalka,mozzarella,rajčatové sugo,salám', 169, 'pizza', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (4, 'Capricciosa', 'bazalka,mozzarella,rajčatové sugo,šunka,žampiony', 179, 'pizza', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (5, 'Diavola', 'bazalka,mozzarella,pálivý salám,rajčatové sugo', 169, 'pizza', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (6, 'Quatro formaggi','bazalka,čtyři druhy sýra,rajčatové sugo', 159, 'pizza', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (7, 'Tonno', 'bazalka,mozzarella,rajčatové sugo,tuňák', 169, 'pizza', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (8, 'Napoletana', 'ančovičky,bazalka,kapary,mozzarella,rajčatové sugo', 189, 'pizza', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (9, 'Bacon', 'bazalka,cibule,mozzarella,rajčatové sugo,slanina', 189, 'pizza', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (10, 'Verona', 'bazalka,kuřecí maso,mozzarella,niva,rajčatové sugo,slanina', 199, 'pizza', 'true');

insert into food (id, title, ingredients, price, category, is_public) values (11, 'Hamburger', 'cibule,domácí bulka,hovězí mleté maso,majonéza,kyselá okurka,rajče,salát', 179, 'burger', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (12, 'Cheeseburger', 'cheddar,domácí bulka,hovězí mleté maso,majonéza,kyselá okurka,rajče,salát', 189, 'burger', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (13, 'BBQ Burger', 'cheddar,domácí bulka,hovězí mleté maso,karamelizovaná cibulka,majonéza,salát,slanina', 199, 'burger', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (14, 'Chickenburger', 'cheddar,domácí bulka,grilovaný kuřecí steak,majonéza,salát,rajče', 179, 'burger', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (15, 'Fit Chickenburger', 'avokádo,celozrnná domácí bulka,grilovaný kuřecí steak,jogurtová majonéza,rajče,rukola', 179, 'burger', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (16, 'Chilliburger', 'cheddar,chilli omáčka,domácí bulka,hovězí mleté maso,majonéza,salát,slanina', 199, 'burger', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (17, 'Cheeseburger Special', 'cheddar,domácí bulka,hovězí mleté maso,karamelizovaná cibulka,majonéza,raclette,salát,slanina', 199, 'burger', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (18, 'Big Country Burger', 'cheddar,domácí bulka,dvojité hovězí mleté maso,karamelizovaná cibulka,majonéza,salát,slanina', 199, 'burger', 'true');

insert into food (id, title, ingredients, price, category, is_public) values (19, 'Bruschetta', 'bazalka,česnek,opečený toskánský chléb,olivový olej,rajčata', 99, 'ostatní', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (20, 'Bruschetta prosciutto', 'bazalka,česnek,opečený toskánský chléb,mozzarella,olivový olej,prosciutto', 109, 'ostatní', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (21, 'Hranolky', 'tenký řez', 79, 'ostatní', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (22, 'Batátové hranolky', 'tenký řez', 89, 'ostatní', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (23, 'Steakové hranolky', 'široký řez', 89, 'ostatní', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (24, 'Sýrový talíř', 'gouda,mozzarella,olivy,parmezán,roquefort', 119, 'ostatní', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (25, 'Uzeninový talíř', 'mortadella bologna,negroni,prosciutto', 119, 'ostatní', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (26, 'Tatarská omáčka', '', 39, 'ostatní', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (27, 'Sweet chilli omáčka', '', 39, 'ostatní', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (28, 'BBQ omáčka', '', 39, 'ostatní', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (29, 'Česnekový dip', '', 39, 'ostatní', 'true');
insert into food (id, title, ingredients, price, category, is_public) values (30, 'Kečup', '', 39, 'ostatní', 'true');


-- ORDER FOOD LINK MOCK
insert into orderFoodLink (id, order_id, food_id) values (1, 1, 7);
insert into orderFoodLink (id, order_id, food_id) values (2, 1, 5);
insert into orderFoodLink (id, order_id, food_id) values (3, 1, 16);
insert into orderFoodLink (id, order_id, food_id) values (4, 1, 12);
insert into orderFoodLink (id, order_id, food_id) values (5, 2, 7);
insert into orderFoodLink (id, order_id, food_id) values (6, 2, 20);
insert into orderFoodLink (id, order_id, food_id) values (7, 2, 17);
insert into orderFoodLink (id, order_id, food_id) values (8, 2, 23);
insert into orderFoodLink (id, order_id, food_id) values (9, 3, 10);
insert into orderFoodLink (id, order_id, food_id) values (10, 3, 13);
insert into orderFoodLink (id, order_id, food_id) values (11, 4, 3);
insert into orderFoodLink (id, order_id, food_id) values (12, 4, 6);
insert into orderFoodLink (id, order_id, food_id) values (13, 5, 10);
insert into orderFoodLink (id, order_id, food_id) values (14, 5, 1);
insert into orderFoodLink (id, order_id, food_id) values (15, 6, 8);
insert into orderFoodLink (id, order_id, food_id) values (16, 6, 9);
insert into orderFoodLink (id, order_id, food_id) values (17, 7, 15);
insert into orderFoodLink (id, order_id, food_id) values (18, 7, 30);
insert into orderFoodLink (id, order_id, food_id) values (19, 8, 11);
insert into orderFoodLink (id, order_id, food_id) values (20, 8, 14);
insert into orderFoodLink (id, order_id, food_id) values (21, 7, 12);
insert into orderFoodLink (id, order_id, food_id) values (22, 8, 5);
insert into orderFoodLink (id, order_id, food_id) values (23, 7, 1);
insert into orderFoodLink (id, order_id, food_id) values (24, 8, 17);
insert into orderFoodLink (id, order_id, food_id) values (25, 8, 19);
insert into orderFoodLink (id, order_id, food_id) values (26, 9, 27);
insert into orderFoodLink (id, order_id, food_id) values (27, 9, 14);
insert into orderFoodLink (id, order_id, food_id) values (28, 9, 2);
insert into orderFoodLink (id, order_id, food_id) values (29, 9, 22);
insert into orderFoodLink (id, order_id, food_id) values (30, 11, 28);
insert into orderFoodLink (id, order_id, food_id) values (31, 13, 5);
insert into orderFoodLink (id, order_id, food_id) values (32, 12, 29);
insert into orderFoodLink (id, order_id, food_id) values (33, 12, 17);
insert into orderFoodLink (id, order_id, food_id) values (34, 11, 30);
insert into orderFoodLink (id, order_id, food_id) values (35, 10, 30);
insert into orderFoodLink (id, order_id, food_id) values (36, 13, 7);
insert into orderFoodLink (id, order_id, food_id) values (37, 13, 6);
insert into orderFoodLink (id, order_id, food_id) values (38, 12, 12);
insert into orderFoodLink (id, order_id, food_id) values (39, 11, 15);
insert into orderFoodLink (id, order_id, food_id) values (40, 12, 17);
insert into orderFoodLink (id, order_id, food_id) values (41, 10, 24);
insert into orderFoodLink (id, order_id, food_id) values (42, 13, 27);
insert into orderFoodLink (id, order_id, food_id) values (43, 10, 6);
insert into orderFoodLink (id, order_id, food_id) values (44, 13, 11);
insert into orderFoodLink (id, order_id, food_id) values (45, 10, 4);
insert into orderFoodLink (id, order_id, food_id) values (46, 11, 21);
insert into orderFoodLink (id, order_id, food_id) values (48, 13, 10);
insert into orderFoodLink (id, order_id, food_id) values (49, 14, 10);
insert into orderFoodLink (id, order_id, food_id) values (50, 14, 22);
insert into orderFoodLink (id, order_id, food_id) values (51, 15, 2);
insert into orderFoodLink (id, order_id, food_id) values (52, 15, 24);
insert into orderFoodLink (id, order_id, food_id) values (53, 15, 27);
insert into orderFoodLink (id, order_id, food_id) values (54, 15, 1);
insert into orderFoodLink (id, order_id, food_id) values (55, 15, 10);
insert into orderFoodLink (id, order_id, food_id) values (56, 15, 14);
insert into orderFoodLink (id, order_id, food_id) values (57, 16, 8);
insert into orderFoodLink (id, order_id, food_id) values (58, 16, 23);
insert into orderFoodLink (id, order_id, food_id) values (59, 17, 1);
insert into orderFoodLink (id, order_id, food_id) values (60, 17, 13);
insert into orderFoodLink (id, order_id, food_id) values (61, 18, 28);
insert into orderFoodLink (id, order_id, food_id) values (62, 18, 10);
insert into orderFoodLink (id, order_id, food_id) values (63, 18, 29);
insert into orderFoodLink (id, order_id, food_id) values (64, 18, 15);
insert into orderFoodLink (id, order_id, food_id) values (65, 18, 25);
insert into orderFoodLink (id, order_id, food_id) values (66, 19, 26);
insert into orderFoodLink (id, order_id, food_id) values (67, 19, 25);
insert into orderFoodLink (id, order_id, food_id) values (68, 19, 27);
insert into orderFoodLink (id, order_id, food_id) values (69, 19, 29);
insert into orderFoodLink (id, order_id, food_id) values (70, 20, 15);
insert into orderFoodLink (id, order_id, food_id) values (71, 20, 13);
insert into orderFoodLink (id, order_id, food_id) values (72, 20, 26);
insert into orderFoodLink (id, order_id, food_id) values (73, 20, 8);
insert into orderFoodLink (id, order_id, food_id) values (74, 20, 18);
insert into orderFoodLink (id, order_id, food_id) values (75, 20, 27);
insert into orderFoodLink (id, order_id, food_id) values (76, 21, 16);
insert into orderFoodLink (id, order_id, food_id) values (77, 21, 2);
insert into orderFoodLink (id, order_id, food_id) values (78, 22, 7);
insert into orderFoodLink (id, order_id, food_id) values (79, 22, 23);
insert into orderFoodLink (id, order_id, food_id) values (80, 22, 24);
insert into orderFoodLink (id, order_id, food_id) values (81, 22, 2);
insert into orderFoodLink (id, order_id, food_id) values (82, 22, 25);
insert into orderFoodLink (id, order_id, food_id) values (83, 22, 14);
insert into orderFoodLink (id, order_id, food_id) values (84, 22, 25);
insert into orderFoodLink (id, order_id, food_id) values (85, 22, 25);
insert into orderFoodLink (id, order_id, food_id) values (86, 22, 16);
insert into orderFoodLink (id, order_id, food_id) values (87, 23, 28);
insert into orderFoodLink (id, order_id, food_id) values (88, 23, 5);
insert into orderFoodLink (id, order_id, food_id) values (89, 23, 8);
insert into orderFoodLink (id, order_id, food_id) values (90, 23, 29);
insert into orderFoodLink (id, order_id, food_id) values (91, 24, 2);
insert into orderFoodLink (id, order_id, food_id) values (92, 24, 3);
insert into orderFoodLink (id, order_id, food_id) values (93, 24, 22);
insert into orderFoodLink (id, order_id, food_id) values (94, 24, 21);
insert into orderFoodLink (id, order_id, food_id) values (95, 24, 30);
insert into orderFoodLink (id, order_id, food_id) values (96, 24, 26);
insert into orderFoodLink (id, order_id, food_id) values (97, 25, 20);
insert into orderFoodLink (id, order_id, food_id) values (98, 25, 11);
insert into orderFoodLink (id, order_id, food_id) values (99, 25, 17);


