-- DROP FUNCTION IF EXISTS hitung_ip;
DELIMITER //

CREATE FUNCTION hitung_ip(target_nim VARCHAR(10))
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE total_bobot FLOAT DEFAULT 0;
    DECLARE total_sks INT DEFAULT 0;
    DECLARE selesai INT DEFAULT 0;

    DECLARE v_sks INT;
    DECLARE v_nilai CHAR(1);
    DECLARE v_bobot INT;

    DECLARE cur CURSOR FOR
        SELECT mk.sks, n.nilai_abjad
        FROM nilaimhs n
        JOIN mk ON n.kode_mk = mk.kode_mk
        WHERE n.nim = target_nim;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET selesai = 1;

    OPEN cur;

    baca_loop: LOOP
        FETCH cur INTO v_sks, v_nilai;
        IF selesai = 1 THEN
            LEAVE baca_loop;
        END IF;

        -- Konversi nilai ke bobot
        IF v_nilai = 'A' THEN SET v_bobot = 4;
        ELSEIF v_nilai = 'B' THEN SET v_bobot = 3;
        ELSEIF v_nilai = 'C' THEN SET v_bobot = 2;
        ELSEIF v_nilai = 'D' THEN SET v_bobot = 1;
        ELSE SET v_bobot = 0;
        END IF;

        SET total_bobot = total_bobot + (v_sks * v_bobot);
        SET total_sks = total_sks + v_sks;
    END LOOP;

    CLOSE cur;

    IF total_sks > 0 THEN
        RETURN total_bobot / total_sks;
    ELSE
        RETURN 0;
    END IF;
END;
//

DELIMITER ;
