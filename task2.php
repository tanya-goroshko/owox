<?php
    function checkBrackets($s)
    {
        $len = strlen($s);
        $stack = array();
        for ($i = 0; $i < $len; $i++) {
            switch ($s[$i]) {
                case '(': array_push($stack, 0); break;
                case ')':
                    //check if opening bracket appeared
                    if (array_pop($stack) !== 0)
                        return false;
                    break;
                case '[': array_push($stack, 1); break;
                case ']':
                    //check if opening bracket appeared
                    if (array_pop($stack) !== 1)
                        return false;
                    break;
                default: break;
            }
        }
        return true;
    }