-- Create table
CREATE TABLE Snow_cover2 (
    Site VARCHAR NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1950 AND 2015),
    Date DATE NOT NULL,
    Plot VARCHAR, -- some Null in the data :/
    Location VARCHAR NOT NULL,
    Snow_cover INTEGER CHECK (Snow_cover > -1 AND Snow_cover < 101),
    Observer VARCHAR
);

-- import from csv
COPY Snow_cover2 FROM 'snow_cover_fixedman_JB.csv' (HEADER TRUE);

-- trigger
CREATE TRIGGER Update_species
AFTER INSERT ON Species
FOR EACH ROW
BEGIN
    UPDATE Species
    SET Scientific_name = NULL
    WHERE Code = new.Code and Scientific_name = '';
END;