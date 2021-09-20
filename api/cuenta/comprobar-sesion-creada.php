<?php
session_start();
echo isset($_SESSION['id_usuario']) ? 1 : 0;
?>