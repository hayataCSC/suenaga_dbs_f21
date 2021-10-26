INSERT INTO climbs (climb_name, climb_grade, crag_name)
    VALUES ('Grand Bohemian',       12, 'Monastery'), -- 1 sport
           ('Nomad',                12, 'Monastery'), -- 2 sport
           ('Mission Creep',        11, 'Monastery'), -- 3 sport
           ('The Heretic',           8, 'Monastery'), -- 4 trad
           ('Spork',                11, 'Monastery'), -- 5 mixed route, with elements of sport AND trad.
           ('Vagabond',             12, 'Monastery'), -- 6 
           ('Parajna',              12, 'Monastery'), -- 7
           ('Licifer''s Unicycle',  10, 'Monastery'), -- 8
           ('Choss Gully Wrangling', 8, 'Monastery'), -- 9
           ('Return to Balance',    11, 'Slab City'), -- 10
           ('Child of the Earth',   12, 'Slab City'), -- 11
           ('Sacred Stones',        11,	'Slab City'), -- 12
           ('Go West',	             7,	'Slab City'), -- 13 trad
           ('Flash Point',          12,	'Slab City'), -- 14 trad
           ('Strip the Willows',    11, 'Slab City'), -- 15
           ('Thrillbillies',        10,	'Slab City'), -- 16
           ('Iron Lung',            12, 'Slab City'); -- 17

INSERT INTO sport_climbs (climb_id, climb_bolts)
    VALUES ( 1, 10), -- Grand Bohemian has 10 bolts,
           ( 5,  4), -- Spork has 4 bolts.
           (10,  5),
           (11,  6),
           (12,  7),
           (15,  8),
           (16,  9),
           (17,  6);

INSERT INTO trad_climbs (climb_id, climb_descent)
    VALUES ( 4, 'rap rings'),      -- The Heretic has a bolt anchor to descend on.
           ( 5, 'rap rings'),      -- Spork has a bolt anchor to descend on.
           (13, 'rap rings'),
           (14, 'rap rings');

-- Q: Can we insert into a view? 
-- A: "Can not modify more than one base table through a join view"