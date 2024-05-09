-- trigger statement
-- the use of IFNULL is kind of like an if else statement, where if it's null, it does the first thing. IF not, it returns the second value
CREATE TRIGGER egg_filler
    AFTER INSERT ON Bird_eggs
    FOR EACH ROW
    BEGIN
        UPDATE Bird_eggs
        SET Egg_num = IFNULL(
            (SELECT MAX(Egg_num) + 1 FROM Bird_eggs WHERE Nest_ID = NEW.Nest_ID),
            1)
        WHERE rowid = NEW.rowid;
    END;

