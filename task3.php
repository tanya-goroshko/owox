<?php
    function myStrRev($s)
    {
        $encoding = mb_detect_encoding($s);

        //get length depending on encoding
        $length = mb_strlen($s, $encoding);

        $rev_str = '';
        while ($length-- > 0)
            //get rev_str from ending
            $rev_str .= mb_substr($s, $length, 1, $encoding);

        return $rev_str;
    }