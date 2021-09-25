SET GLOBAL event_scheduler = ON;

DELIMITER //

CREATE EVENT eliminar_visitas_ultimas_24_horas_predios_actividades 
ON SCHEDULE EVERY 24 hour
    STARTS CURDATE() + INTERVAL 00 HOUR 
    ENDS CURDATE() + INTERVAL 00 HOUR + INTERVAL 1 DAY
ON COMPLETION PRESERVE
DO BEGIN
    UPDATE tbl_predios SET vistas_ultimas_24_horas = 0;
    UPDATE tbl_actividades SET vistas_ultimas_24_horas = 0;
END//

DELIMITER ;