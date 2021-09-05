<?php
    $table = isset($_GET['table']) ? $_GET['table'] : 'tbl_usuarios';
    $bd = isset($_GET['bd']) ? $_GET['bd'] : 'db_turnos';

    $pdo = new PDO("mysql:host=localhost; dbname=$bd",'USER_DML','rivadavia');
    $pdo->exec("SET NAMES 'utf8'");
    
    $tables = $pdo->query('SHOW TABLES;')->fetchAll(PDO::FETCH_NUM);
    $columns = $pdo->query("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '$table' AND TABLE_SCHEMA = '$bd';")->fetchAll(PDO::FETCH_NUM);
    $data = $pdo->query("SELECT * FROM $table;")->fetchAll(PDO::FETCH_NUM);
    
    $pdo = null;
?>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Tablas MySQL</title>
        <style>
            body,
            h1 {
                margin: 0;
                background-color: #fff;
            }

            body {
                font-family: Arial, Helvetica, sans-serif;
                background-color: #34495e;
            }

            h1 {
                border-bottom: 2px solid #000;
                text-align: center;
            }

            .buttons-table{
                background-color:red;
                display:flex;
                flex-direction: row;
                flex-wrap: wrap;
            }

            .buttons-table > button {
                flex:1 1 auto;
                border-radius: 0;
                border-color: #000;
                color: blue;
            }

            table {
                width: 100%;
                margin: 100px auto 0;
            }

            table, tr, td{
                border: 1px solid #000;
                border-collapse: collapse;
            }

            td{
                height: 3em;
                padding-left: .5%;
            }

            tr{
                background-color: #fff;
            }

            tr:nth-child(1){
                background-color: #130f40;
                color: #fff;
            }

            tr:nth-child(2n){
                background-color: #1abc9c;
            }
        </style>
    </head>
    <body>
        <h1>Tablas MySQL</h1>
        <div class='buttons-table'>
            <?php
            foreach ($tables as $value) {
                $value = $value[0];
                echo "<button 
                        onclick= 'redireccionar(`?table=$value&bd=$bd`)'
                    > 
                        $value 
                    </button>";
            }
            ?>
        </div>
        <table>
            <tr>
                <?php
                    foreach ($columns as $value) {
                        echo '<th>'. $value[0]. '</th>';
                    };
                ?>
            </tr>
            <?php
                foreach ($data as $arr) {
                    echo '<tr>';

                    foreach ($arr as $value) {
                        echo "<td>$value</td>";
                    };

                    echo '</tr>';
                };
            ?>
        </table>
        <script>
            const redireccionar = (link) => location = link;
        </script>
    </body>
</html>
