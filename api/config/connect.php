<?php

$host = "localhost";
$user = "root";
$pass = "";
$db   = "uas_pmob";

$conn = new mysqli(
    $host,
    $user,
    $pass,
    $db
);

if ($conn->connect_error) {
    die("Database Error");
}