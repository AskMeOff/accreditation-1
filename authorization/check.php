<?php
include '../ajax/connection.php';
$id = $_GET['id'];
SetCookie("login1", $_COOKIE["login"]);
mysqli_query($con, "UPDATE users SET online=0, last_time_session=null WHERE id_user='$id'"); //обнуляется поле online, говорящее, что пользователь вышел с сайта (пригодится в будущем)
unset($_SESSION['id_user']); //удалятся переменная сессии

SetCookie("login", "", time() - 3600, "/");
SetCookie("PHPSESSID", "", time() - 3600, "/");
SetCookie("isMA", "", time() - 3600, "/");
SetCookie("id_user", "", time() - 3600, "/");
SetCookie("expert", "", time() - 3600, "/");
SetCookie("predsedatel", "", time() - 3600, "/");
SetCookie("secretar", "", time() - 3600, "/");
SetCookie("password", "", time() - 3600, "/");

//header('Location: http://'.$_SERVER['HTTP_HOST'].'/index.php'); //перенаправление на главную страницу сайта


