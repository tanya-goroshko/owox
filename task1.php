<?php
    function searchInArray($a, $b)
    {
        $start_index = 0;
        $stop_index = count($a) - 1;
        $middle = floor(($stop_index + $start_index) / 2);

        while($a[$middle] != $b && $start_index < $stop_index){

            //config search area
            if ($b < $a[$middle]){
                $stop_index = $middle - 1;
            } else if ($b > $a[$middle]){
                $start_index = $middle + 1;
            }

            //recalculate middle
            $middle = floor(($stop_index + $start_index) / 2);
        }

        return ($a[$middle] != $b) ? false : true;
    }