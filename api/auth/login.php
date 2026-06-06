<?php

header("Content-Type: application/json");
header('Access-Control-Allow-Origin: *'); 
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

require_once "../config/connect.php";

$data = json_decode(
    file_get_contents("php://input"),
    true
);

$username = $data["username"] ?? "";
$password = $data["password"] ?? "";

$stmt = $conn->prepare(
    "SELECT * FROM users WHERE username = ?"
);

$stmt->bind_param("s", $username);
$stmt->execute();

$result = $stmt->get_result();

if ($result->num_rows == 0) {

    echo json_encode([
        "success" => false,
        "message" => "User tidak ditemukan"
    ]);

    exit;
}

$user = $result->fetch_assoc();
if($password == $user["password"]){
    echo json_encode([
        "success" => true,
        "user" => [
            "id" => $user["id"],
            "username" => $user["username"],
            "role" => $user["role"],
            "table_number" => $user["table_number"]
        ]
    ]);
    exit;
}
// if (!password_verify(
//         $password,
//         $user["password"]
//     )) {

//     echo json_encode([
//         "success" => false,
//         "message" => "Password salah"
//     ]);

//     exit;
// }

echo json_encode([
    "success" => true,
    "user" => [
        "id" => $user["id"],
        "username" => $user["username"],
        "role" => $user["role"],
        "table_number" => $user["table_number"]
    ]
]);