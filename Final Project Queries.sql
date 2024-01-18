USE restaurants_db;
-- This view counts the number of locations that serves burgers by street name.
CREATE VIEW BurgerLocation_by_street AS
	SELECT COUNT(rest_id) AS number_of_restaurants, street_name, menu_item_id
	FROM restaurants
	JOIN menu_items_restaurants USING(rest_id)
	JOIN menu_items USING (menu_item_id)
	WHERE menu_item_id = 2
    Group by street_name;
-- This view selects the restaurants that use grub hub for delivery. 
CREATE VIEW restaurants_using_grub_hub AS 
	SELECT DISTINCT rest_name AS 'Restaurant Name', cuisine_type AS 'Cousine Type'
	FROM restaurants
	WHERE rest_id IN 
	(SELECT rest_id FROM (SELECT rest_id, rest_name, delivery_option_name, delivery_option_price
	FROM restaurants
		JOIN delivery_options_restaurants USING(rest_id)
		JOIN delivery_options USING(delivery_option_id)
	WHERE delivery_option_name = 'grub hub')t);
-- This view Selects the restaurants that serve noodles and displays the price and locations
CREATE VIEW restaurants_serving_noodles AS 
	SELECT rest_name AS 'Restaurant Name', item_name_specific, CONCAT('$', item_price),
	CONCAT(street_num, ' ', street_name) AS 'location'
	FROM restaurants 
		JOIN menu_items_restaurants USING(rest_id)
    		JOIN menu_items USING(menu_item_id)
	WHERE item_name_generic = 'noodles';
-- This view counts the number of restaurants that are hiring cashiers
CREATE VIEW number_restaurants_hiring_cashier AS 
	SELECT COUNT(rest_id)
	FROM restaurants
		JOIN available_positions_restaurants USING(rest_id)
    		JOIN available_positions USING(available_position_id)
	WHERE available_position_title = 'cashier';
-- This view counts the average price of the of generic food items
CREATE VIEW generic_item_amount_average AS 
	SELECT item_name_generic AS 'Generic Name', COUNT(menu_item_id) AS 'Number of Selections', 
	CONCAT('$',FORMAT(AVG(item_price),2)) AS 'Average Price'
	FROM menu_items
		JOIN menu_items_restaurants USING(menu_item_id)
GROUP BY item_name_generic;