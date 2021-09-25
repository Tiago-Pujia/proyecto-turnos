<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception; 

include_once 'composer/vendor/phpmailer/phpmailer/src/Exception.php';
include_once 'composer/vendor/phpmailer/phpmailer/src/PHPMailer.php';
include_once 'composer/vendor/phpmailer/phpmailer/src/SMTP.php';

class Mailer {
    private $username = 'turnoslamatanza@gmail.com';
    private $password = 'dragonzzz1';
    private $host = 'smtp.gmail.com';

    public function enviar_mail($email_recibidor,$asunto,$cuerpo){
        $mail = new PHPMailer(true);
    
        $mail->SMTPDebug = 0;
        $mail->isSMTP(true);
        $mail->Host       = $this->host;
        $mail->SMTPAuth   = true;
        $mail->Username   = $this->username;
        $mail->Password   = $this->password;
        $mail->SMTPSecure = 'tls';
        $mail->Port       = 587;
        
        $mail->setFrom($this->username);
        $mail->addAddress($email_recibidor);
        
        $mail->isHTML(true);
        $mail->Subject = $asunto;
        $mail->Body    = $cuerpo;
        
        return($mail->send());    
    }
}

class Enviar_Correos extends Mailer{
    public function activar_cuenta($receptor_email,$id_usuario,$token_password){
        $asunto = 'Activar cuenta dada de baja';
        $cuerpo = '
            <h1 style="color:red;">Enviaste una solicitud para activar tu cuenta dada de baja</h1>
            <p>Haga click en el boton</p>
            <p><a href="' . $_SERVER['SERVER_NAME'] . '/cuenta/reactivar-cuenta/?id_usuario=' . $id_usuario . '&token=' . $token_password . '">Activar</a></p>'
            ;
        // urldecode(substr($password_bd,29))
        $this->enviar_mail($receptor_email,$asunto,$cuerpo);    
    }

    public function confirmar_correo($receptor_email,$id_usuario,$token){
        $asunto = 'Gracias por registrarte, por favor verifique su cuenta';
        $cuerpo = '
        <h1 style="color:red;">Verificacion de Correo electronico</h1>
        <p>Haga click en el boton</p>
        <p><a href="' . $_SERVER['SERVER_NAME'] . '/cuenta/confirmar-correo/?id_usuario=' . $id_usuario . '&token=' . $token . '">Verificar</a></p>'
        ;

        $this->enviar_mail($receptor_email,$asunto,$cuerpo);    
    }

    public function olvide_contrasena($receptor_email,$id_usuario,$token){
        $asunto = 'Cambiar contraseña';
        $cuerpo = '
        <p>Enviaste una peticion de cambiar contraseña por olvido, entra al 
        <a href="'  . $_SERVER['SERVER_NAME'] . '/cuenta/olvide-contrasena/?id_usuario=' . $id_usuario . '&token=' . $token . '">
            enlace
        </a> 
        para cambiarla
        </p>'
        ;

        $this->enviar_mail($receptor_email,$asunto,$cuerpo);
    }

    function __destruct(){}
}

?>
