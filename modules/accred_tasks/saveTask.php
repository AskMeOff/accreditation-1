<?php

include "../../connection.php";

$id_application = $_POST['id_application'];
$date_accept = $_POST['date_accept'];
$date_complete = $_POST['date_complete'];

$date_council = $_POST['date_council'];
if(empty($date_accept)){
    $date_accept = "null";
} else {
    $date_accept = "'$date_accept'";
}


echo "\"$date_accept\"";

if(empty($date_complete)){
    $date_complete = "null";

} else {
    $date_complete = "'$date_complete'";
}


if(empty($date_council)){
    $date_council = "null";
} else {
    $date_council = "'$date_council'";
}

//$query_srt .= " WHERE id_application = '$id_application'";
$query = "Update applications set date_accept = {$date_accept}, date_complete = {$date_complete}, date_council = {$date_council} WHERE id_application = '$id_application'";


mysqli_query($con, $query) or die("Ошибка " . mysqli_error($con));

echo "OK";
?>