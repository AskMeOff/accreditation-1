<?php
include "connection.php";

$id_sub = $_POST['id_sub'];
class Stats{
    public $id_criteria, $status;
}
//$id_criteria = $_POST['id_criteria'];
//$result = mysqli_query($con, "SELECT status FROM rating_criteria as rc WHERE rc.id_subvision = '$id_sub' AND rc.id_criteria = '$id_criteria' and rc.value = 1");
$result = mysqli_query($con, "SELECT status, id_criteria FROM rating_criteria as rc WHERE rc.id_subvision = '$id_sub' and rc.value = 1");
//$status = $row['status'];
$status = array();
for ($data = []; $row = mysqli_fetch_assoc($result); $data[] = $row);
foreach ($data as $app) {
    $stats = new Stats();
    $stats->id_criteria = $app['id_criteria'];
    $stats->status = $app['status'];
    array_push($status, $stats);
}
echo json_encode($status);
?>