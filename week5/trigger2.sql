-- trigger statement pt 2
CREATE TRIGGER egg_filler2
AFTER INSERT ON Bird_eggs
FOR EACH ROW
BEGIN
    UPDATE Bird_eggs
    SET 
        Egg_num = IFNULL(
            (SELECT MAX(Egg_num) + 1 FROM Bird_eggs WHERE Nest_ID = NEW.Nest_ID),
            1),
        Book_page = (SELECT Book_page FROM Bird_nests WHERE Nest_ID = NEW.Nest_ID),
        Year = (SELECT Year FROM Bird_nests WHERE Nest_ID = NEW.Nest_ID),
        Site = (SELECT Site FROM Bird_nests WHERE Nest_ID = NEW.Nest_ID)
    WHERE rowid = NEW.rowid;
END;