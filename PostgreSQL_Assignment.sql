CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100),
    contact_info TEXT
);
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(150) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) NOT NULL
);
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers(ranger_id),
    species_id INT REFERENCES species(species_id),
    sighting_time TIMESTAMP NOT NULL,
    location TEXT NOT NULL,
    notes TEXT
);

-- Insert into rangers
INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

-- Insert into species
INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

-- Insert into sightings
INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

SELECT * FROM rangers;
SELECT * from sightings;
SELECT * from species;

--Problem-1
--Add a ranger named 'Derek Fox' in the 'Coastal Plains' region
INSERT INTO rangers(name, region)
VALUES('Derek Fox', 'Coastal Plains');

--Problem-2
--Count unique species ever sighted
SELECT count(DISTINCT species_id) as unique_species_count 
FROM sightings;

--Problem-3
--Find all sightings where the location includes "Pass".

SELECT * FROM sightings WHERE location ILIKE '%Pass%';

--Problem-4
--List each ranger's name and their total number of sightings.
SELECT rangers.name, count(sightings.sighting_id) as total_sightings FROM rangers
JOIN sightings ON rangers.ranger_id= sightings.ranger_id
GROUP BY rangers.name
ORDER BY rangers.NAME

--Problem-5
--List species that have never been sighted
SELECT species.common_name from species
LEFT JOIN sightings ON species.species_id = sightings.species_id
WHERE sightings.species_id IS NULL;

--Problem-6
--Show the most recent 2 sightings 

SELECT species.common_name, sightings.sighting_time, rangers.name
FROM sightings
JOIN species ON sightings.species_id = species.species_id
JOIN rangers ON sightings.ranger_id = rangers.ranger_id
ORDER BY sightings.sighting_time DESC
LIMIT 2

--Problem-7
--Update all species discovered before year 1800 to 'Historic'

UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01'

--Problem-8
--Label each sighting's time of day

SELECT sighting_id,
    case
        WHEN EXTRACT(HOUR from sighting_time)<12 THEN 'Morning'
        WHEN EXTRACT(HOUR from sighting_time)<17 THEN 'Afternoon'
        else 'Evening'
    END as time_of_day
FROM sightings;

--Problem-9
--Delete rangers who have never sighted any species

DELETE FROM rangers
WHERE ranger_id NOT IN(
    SELECT DISTINCT ranger_id FROM sightings
);

