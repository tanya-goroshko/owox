<?php
    $order_data = array();

    array_push($order_data, new Order(1, time(), 'ip'));

    new makeOrder($order_data);

    class makeOrder
    {
        public $order_data;
        private $query = "START TRANSACTION; INSERT INTO orders(id, client_id, created, ip) VALUES ";
        private $servername = 'localhost';
        private $username = "username";
        private $password = "password";

        public function __construct($data)
        {
            $this->order_data = $data;
            $this->makeQuery();
        }

        private function makeQuery()
        {
            $comma = "";
            foreach ($this->order_data as $data)
            {
                $this->query .= $comma . "(" . $data->client_id . ", " . $data->created . ", '" . $data->ip . "')";
                $comma = ", ";
            }

            $this->query .= "; INSERT INTO order_item(order_id, product_id, amount)".
                "VALUES ";

            $comma = "";
            foreach ($this->order_data as $data)
            {
                foreach ($data->products as $prod)
                {
                    $this->query .= $comma . "(" . $prod->order_id . ", " . $prod->product_id . ", " . $prod->amount . ")";
                    $comma = ", ";
                }
            }

            $this->query .= ";";

            $mysqli = new mysqli($this->servername, $this->username, $this->password);

            if ($mysqli->connect_errno)
                die("Не удалось подключиться к MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error);

            if (!$mysqli->multi_query($this->query)) {
                echo "Не удалось выполнить мультизапрос: (" . $mysqli->errno . ") " . $mysqli->error;
                $this->query = "ROLLBACK;";
                $mysqli->query($this->query);
                $mysqli->close();
            }else{
                $this->query = "COMMIT;";
                $mysqli->query($this->query);
                $mysqli->close();
            }
        }
    }

    class Order
    {
        public $client_id;
        public $created;
        public $ip;
        public $products = [];

        public function __construct($id, $when_created, $ip)
        {
            $this->client_id = $id;
            $this->created = $when_created;
            $this->ip = $ip;

            for($j = 1; $j < 6; $j++)
            {
                array_push($this->products, new Product($j, $id, rand(1, 10)));
            }
        }
    }

    class Product
    {
        public $order_id;
        public $product_id;
        public $amount;

        public function __construct($id, $order_id, $amnt)
        {
            $this->product_id = $id;
            $this->order_id = $order_id;
            $this->amount = $amnt;
        }
    }