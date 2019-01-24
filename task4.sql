CREATE TABLE IF NOT EXISTS `products` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(128) NOT NULL,
    `description` TEXT NOT NULL,
    `price` decimal(10, 2) unsigned DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `clients` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(128) NOT NULL,
    `email` VARCHAR(64) NOT NULL,
    `phone` VARCHAR(12) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `orders` (
    `id` SMALLINT(11) NOT NULL AUTO_INCREMENT,
    `client_id` INT(11) NOT NULL,
    `created` DATETIME NOT NULL,
    `ip` VARCHAR(15) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `foreign_key_client_id` (`client_id` ASC),
    CONSTRAINT `foreign_key_client_id`
    FOREIGN KEY (`client_id` )
    REFERENCES `clients`(`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `order_item` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `order_id` SMALLINT(11) NOT NULL,
  `product_id` INT(11) NOT NULL,
  `amount` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `foreign_key_order_id_index` (`order_id` ASC),
  INDEX `foreign_key_product_id_index` (`product_id` ASC),
  CONSTRAINT `foreign_key_order_id`
    FOREIGN KEY (`order_id` )
    REFERENCES `orders`(`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `foreign_key_product_id`
    FOREIGN KEY (`product_id` )
    REFERENCES `products`(`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)ENGINE = InnoDB;

-- make order through transaction
-- see task4.php file

--select orders with specific products
SELECT `order_item`.`order_id` FROM `order_item`
        INNER JOIN `products` ON `products`.`id` = `order_item`.`product_id`
WHERE `products`.`id` = YOUR_PRODUCT_ID GROUP BY `order_item`.`order_id`;

--select orders of the specific client
SELECT `orders`.`id` FROM `orders`
        INNER JOIN `clients` ON `clients`.`id` = `orders`.`client_id`
WHERE `clients`.`id` = YOUR_CLIENT_ID GROUP BY `orders`.`id`;

--select 10 orders
SELECT `orders`.`id`, `orders`.`created`, `over_one`.`count_product`, `over_one`.`avg_product_price` FROM `orders`
        INNER JOIN (
                SELECT `order_item`.`order_id` `id`, sum(`order_item`.`amount`) AS `count_product`, count(*) AS `cnt`, `average`.`avg_product_price` FROM `order_item`
                    INNER JOIN (
                          SELECT `id`, `price` FROM `products`
                    ) `price` ON `price`.`id` = `order_item`.`product_id`
                    INNER JOIN (
                        SELECT `order_id`, avg(`pr`.`price` * `amount`) AS `avg_product_price` FROM `order_item`
                            INNER JOIN(SELECT `id`, `price` FROM `products`) `pr` ON `pr`.`id` = `order_item`.`product_id` GROUP BY `order_item`.`order_id`
                    ) `average` ON `average`.`order_id` = `order_item`.`order_id`
                GROUP BY `order_item`.`order_id` HAVING `cnt` > 1
        ) `over_one` ON `over_one`.`id` = `orders`.`id`
ORDER BY `orders`.`created` limit 10;