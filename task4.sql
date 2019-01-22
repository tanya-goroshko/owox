CREATE TABLE IF NOT EXISTS `products` (
    `id` INT(11) NOT NULL UNIQUE,
    `name` VARCHAR(128) NOT NULL,
    `description` TEXT NOT NULL,
    `price` decimal(10, 2) unsigned DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = MyISAM;

CREATE TABLE IF NOT EXISTS `clients` (
    `id` INT(11) NOT NULL UNIQUE,
    `name` VARCHAR(128) NOT NULL,
    `email` VARCHAR(64) NOT NULL,
    `phone` VARCHAR(12) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE = MyISAM;

CREATE TABLE IF NOT EXISTS `orders` (
    `id` SMALLINT(11) NOT NULL UNIQUE,
    `client_id` INT(11) NOT NULL,
    `created` DATETIME NOT NULL,
    `ip` VARCHAR(15) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `foreign_key_orders_index_1` (`client_id` ASC),
    CONSTRAINT `foreign_key_orders_1`
    FOREIGN KEY (`client_id` )
    REFERENCES `clients` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
) ENGINE = MyISAM;

CREATE TABLE IF NOT EXISTS `order_item` (
  `id` INT(11) NOT NULL UNIQUE,
  `order_id` INT(11) NOT NULL,
  `product_id` INT(11) NOT NULL,
  `amount` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `foreign_key_order_item_index_1` (`order_id` ASC),
  INDEX `foreign_key_order_item_index_2` (`product_id` ASC),
  CONSTRAINT `foreign_key_order_item_1`
    FOREIGN KEY (`order_id` )
    REFERENCES `orders` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `foreign_key_order_item_2`
    FOREIGN KEY (`product_id` )
    REFERENCES `products` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

