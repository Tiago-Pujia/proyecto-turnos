<?php

class BD {
    private static $db_type = 'mysql';
    private static $db_host = 'localhost';
    private static $db_name = 'db_turnos';
    private static $db_user = 'USER_DML';
    private static $db_pass = 'rivadavia';
    protected $db_connection = null;

    public function conectar(){
        try {
            $dsn = self::$db_type . ":host=" . self::$db_host . ";dbname=" . self::$db_name;
            $this->db_connection = new PDO($dsn,self::$db_user,self::$db_pass);
            $this->db_connection->exec("SET names utf8");
            return $this->db_connection;
        } catch(PDOException $e) {
            exit('Error');
        };
    }

    public function desconectar(){
        $this->db_connection = null;
    }

    function __destruct(){}
}

class CRUD extends BD {
    public function query($query){
        try {
            $this->conectar();
            $respuesta = $this->db_connection->query($query)->fetchAll(PDO::FETCH_NUM);
            $this->desconectar();

            return $respuesta;
        } catch (PDOException $e) {
            return 'Error';
        }
    }

    public function store_procedure($query){
        try {
            $this->conectar();
            $respuesta = $this->db_connection->query($query);
            $this->desconectar();

            return $respuesta;
        } catch (PDOException $e){
            return 'Error';
        }
    }

    public function exec($exec){
        try {
            $this->conectar();
            $respuesta = $this->db_connection->exec($exec);
            $this->desconectar();
            
            return $respuesta;
        } catch (PDOException $e) {
            return 'Error';
        }
    }

    public function query_sin_connection($query){
        try {
            $respuesta = $this->db_connection->query($query)->fetchAll(PDO::FETCH_NUM);

            return $respuesta;
        } catch (PDOException $e) {
            return 'Error';
        }
    }

    public function store_procedure_sin_connection($query){
        try {
            $respuesta = $this->db_connection->query($query);

            return $respuesta;
        } catch (PDOException $e){
            return 'Error';
        }
    }

    public function exec_sin_connection($exec){
        try {
            $respuesta = $this->db_connection->exec($exec);
            
            return $respuesta;
        } catch (PDOException $e) {
            return 'Error';
        }
    }

    function __destruct(){}
}

$crud = new CRUD();

?>