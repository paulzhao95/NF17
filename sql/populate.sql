INSERT INTO TypeTrain (Nom, nbPlacesPrem, nbPlacesSec, vitesseMax) VALUES
('Petit TER', 0, 452, 160),
('Grand TER', 60, 744, 160),
('Intercites', 210, 1008, 200),
('TGV Atlantique', 275, 600, 300),
('TGV Duplex', 364, 656, 320)
;

INSERT INTO Ville (Nom, CP, ZoneHoraire) VALUES
('Paris', 75000, 2),
('Lyon', 69000, 2),
('Compiegne', 60200, 2),
('Bordeaux', 33000, 2),
('Maubeuge', 59600, 2)
;

INSERT INTO Gare (Nom, Adresse, Ville) VALUES
('Bordeaux Saint-Jean', (1, 'rue Charles Domercq'), 'Bordeaux'),
('Gare de Compiegne', (1, 'place de la Gare'), 'Compiegne'),
('Gare de Lyon', (1, 'place Louis Armand'), 'Paris'),
('Gare de Maubeuge', (1, 'rue du Gazometre'), 'Maubeuge'),
('Gare du Nord', (18, 'rue de Dunkerque'), 'Paris'),
('Gare Montparnasse', (17, 'boulevard de Vaugirard'), 'Paris'),
('Lyon Part-Dieu', (5, 'place Charles Beraudier'), 'Lyon')
;

INSERT INTO Hotel (Nom, Adresse, Ville, Gare, PrixNuit) VALUES
('Hotel de Flandre', (16, 'quai de la République'), 'Compiegne', 'Gare de Compiegne', 61)
;

INSERT INTO Ligne (NomGareDep, VilleGareDep, NomGareArr, VilleGareArr, TypeTrain) VALUES
('Gare du Nord', 'Paris', 'Gare de Compiegne', 'Compiegne', 'Grand TER'),
('Gare de Compiegne', 'Compiegne', 'Gare du Nord', 'Paris', 'Grand TER'),
('Gare du Nord', 'Paris', 'Gare de Maubeuge', 'Maubeuge', 'Intercites'),
('Gare de Maubeuge', 'Maubeuge', 'Gare du Nord', 'Paris', 'Intercites'),
('Gare Montparnasse', 'Paris', 'Bordeaux Saint-Jean', 'Bordeaux', 'TGV Atlantique'),
('Bordeaux Saint-Jean', 'Bordeaux', 'Gare Montparnasse', 'Paris', 'TGV Atlantique'),
('Gare de Lyon', 'Paris', 'Lyon Part-Dieu', 'Lyon', 'TGV Duplex'),
('Lyon Part-Dieu', 'Lyon', 'Gare de Lyon', 'Paris', 'TGV Duplex'),
('Gare du Nord', 'Paris', 'Gare de Compiegne', 'Compiegne', 'Intercites'),
('Gare de Compiegne', 'Compiegne', 'Gare du Nord', 'Paris', 'Intercites')
;

INSERT INTO Planning (Nom, Jours, Debut, Fin) VALUES
('Tous les jours', ARRAY[true, true, true, true, true, true, true], NULL, NULL),
('Jours ouvres', ARRAY[true, true, true, true, true, false, false], NULL, NULL),
('Week end', ARRAY[false, false, false, false, false, true, true], NULL, NULL)
;

INSERT INTO Exception (Nom, Ajoute, Planning, DateDebut, DateFin) VALUES
('Vacances printemps 2018', true, 'Week end', '2018-04-14', '2018-04-29'),
('Vacances été 2018', true, 'Week end', '2018-06-30', '2018-09-01'),
('Grève mai 2018', false, 'Jours ouvres', '2018-05-01', '2018-05-08')
;

INSERT INTO Trajet (Ligne, HeureDepart, HeureArrivee, PrixPrem, PrixSec, Planning) VALUES
(2, '07:35:00', '08:26:00', NULL, 015.00, 'Tous les jours'),
(1, '07:34:00', '08:26:00', NULL, 015.00, 'Tous les jours'),
(10, '19:00:00', '19:41:00', 015.00, 013.00, 'Jours ouvres'),
(9, '19:16:00', '19:58:00', 015.00, 013.00, 'Jours ouvres'),
(7, '16:59:00', '18:56:00', 086.00, 052.00, 'Week end'),
(8, '17:04:00', '19:01:00', 086.00, 075.00, 'Jours ouvres')
;

INSERT INTO Voyageur (Nom, Prenom, NumeroTel, NumeroCarte, Ville, Adresse, TypeVoyageur) VALUES
('Zhao', 'Paul', '0605040302', '001234567890', 'Compiegne', (1, 'rue de la Joie'), 'Or'),
('Sabbagh', 'Guillaume', '0123456789', '314159265358', 'Compiegne', (12, 'place du Bonheur'), 'Argent'),
('Delabre', 'Martin', '0607080910', NULL, 'Compiegne', (7, 'avenue du Sourire'), 'Occasionnel'),
('Dubosc', 'Bertille', '0711235813', NULL, 'Compiegne', (88, 'boulevard du Chocolat'), 'Occasionnel')
;

INSERT INTO Reservation (Voyageur, Assurance, MoyenPaiement) VALUES
(4, false, 'carte_bleue'),
(3, false, 'especes'),
(1, true, 'cheque'),
(2, true, 'carte_bleue')
;

INSERT INTO Billet (Trajet, Date, Classe, Place, Annule, Reservation) VALUES
(1, '2018-06-22', '2', 8, false, 1),
(1, '2018-06-22', '2', 9, false, 1),
(1, '2018-06-22', '2', 10, false, 1),
(1, '2018-06-22', '2', 11, false, 1),
(1, '2018-06-22', '2', 23, false, 2),
(1, '2018-06-22', '2', 24, false, 2),
(1, '2018-06-22', '2', 104, false, 3),
(1, '2018-06-22', '2', 105, false, 3),
(1, '2018-06-22', '2', 106, false, 3),
(5, '2018-07-02', '1', 41, false, 4),
(6, '2018-02-08', '2', 31, false, 4)
;

INSERT INTO Gerants (login, mdp) VALUES
('admin','123456789');
