<?php
function crear_token($password) {
    return urldecode(substr($password,29));
}
?>