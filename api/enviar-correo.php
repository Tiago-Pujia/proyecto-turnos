<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception; 

include_once 'composer/vendor/phpmailer/phpmailer/src/Exception.php';
include_once 'composer/vendor/phpmailer/phpmailer/src/PHPMailer.php';
include_once 'composer/vendor/phpmailer/phpmailer/src/SMTP.php';

function sendMail($email_recibidor,$asunto,$cuerpo){
    $mail = new PHPMailer(true);
    
    $mail->SMTPDebug = 0;
    $mail->isSMTP(true);
    $mail->Host       = 'smtp.gmail.com';
    $mail->SMTPAuth   = true;
    $mail->Username   = 'turnoslamatanza@gmail.com';
    $mail->Password   = 'dragonzzz1';
    $mail->SMTPSecure = 'tls';
    $mail->Port       = 587;
    
    $mail->setFrom('turnoslamatanza@gmail.com');
    $mail->addAddress($email_recibidor);
    
    $mail->isHTML(true);
    $mail->Subject = $asunto;
    $mail->Body    = $cuerpo;
    
    $mail->send();    
}

?>
