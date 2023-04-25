select *
from "order"
where address_id=48;

select f.id, f.title, f.ingredients, f.price, f.category, f.is_public
from "order" join orderFoodLink oFL on "order".id = oFL.order_id
    join food f on oFL.food_id = f.id
where "order".id == 14;


select id, title from food where id in (1,2,3,4);

select * from address where city = 'Praha' and street = 'V Záhoří 158' and postal_code = '15800';
select upper(city), upper(street), postal_code from address where id = 51;


insert into address (id, city, street, postal_code) values (51, 'Praha', 'V Záhoří 158', '15800');


select * from "order" where user_id = 5;

