CREATE TYPE Adresse AS
(
    Numero integer,
    NomVoie text
);

CREATE TYPE Classe AS ENUM
('1', '2');

CREATE TYPE MoyenPaiement AS ENUM
('especes', 'cheque', 'carte_bleue');

CREATE TYPE StatutVoyageur AS ENUM
('Occasionnel', 'Argent', 'Or', 'Platine');



CREATE TABLE Ville
(
    Nom varchar PRIMARY KEY,
    CP numeric(5,0) NOT NULL,
    ZoneHoraire integer NOT NULL,
    CONSTRAINT CP_key UNIQUE (CP),
    CONSTRAINT ZoneHor_ok CHECK (ZoneHoraire >= -12 AND ZoneHoraire <= 12)
);

CREATE TABLE Gare
(
    Nom varchar NOT NULL,
    Adresse Adresse NOT NULL,
    Ville varchar NOT NULL,
    CONSTRAINT Gare_pkey PRIMARY KEY (Nom, Ville),
    CONSTRAINT Ville_fkey FOREIGN KEY (Ville)
    REFERENCES Ville (Nom) MATCH SIMPLE
);

CREATE TABLE Hotel
(
    Nom varchar NOT NULL,
    Adresse Adresse NOT NULL,
    Ville varchar NOT NULL,
    Gare varchar,
    PrixNuit integer,
    CONSTRAINT Hotel_pkey PRIMARY KEY (Nom, Ville),
    CONSTRAINT Adresse_Ville_key UNIQUE (Adresse, Ville),
    CONSTRAINT Gare_Ville_fkey FOREIGN KEY (Gare, Ville)
    REFERENCES Gare (Nom, Ville) MATCH SIMPLE,
    CONSTRAINT PrixNuit_pos CHECK (PrixNuit > 0)
);

CREATE TABLE TypeTrain
(
    Nom varchar PRIMARY KEY,
    nbPlacesPrem integer NOT NULL,
    nbPlacesSec integer NOT NULL,
    vitesseMax integer NOT NULL,
    CONSTRAINT nbPlacesPrem_pos CHECK (nbPlacesPrem >= 0),
    CONSTRAINT nbPlacesSec_pos CHECK (nbPlacesSec > 0),
    CONSTRAINT vitesseMax_pos CHECK (vitesseMax > 0)
);

CREATE TABLE Ligne
(
    Id serial PRIMARY KEY,
    NomGareDep varchar,
    VilleGareDep varchar,
    NomGareArr varchar,
    VilleGareArr varchar,
    TypeTrain varchar,
    CONSTRAINT Donnees_uniques UNIQUE (NomGareDep, VilleGareDep, NomGareArr, VilleGareArr, TypeTrain),
    CONSTRAINT GareArr_fkey FOREIGN KEY (NomGareArr, VilleGareArr)
    REFERENCES Gare (Nom, Ville) MATCH SIMPLE,
    CONSTRAINT GareDep_fkey FOREIGN KEY (NomGareDep, VilleGareDep)
    REFERENCES Gare (Nom, Ville) MATCH SIMPLE,
    CONSTRAINT Ligne_TypeTrain_fkey FOREIGN KEY (TypeTrain)
    REFERENCES TypeTrain (Nom) MATCH SIMPLE,
    CONSTRAINT Depart_arrivee_diff CHECK ((NomGareDep, VilleGareDep) <> (NomGareArr, VilleGareArr)),
    CONSTRAINT Id_diff_0 CHECK (Id <> 0)
);

CREATE TABLE Planning
(
    Nom varchar PRIMARY KEY,
    Jours boolean[7] NOT NULL,
    Debut date,
    Fin date,
    CONSTRAINT Donnees_key UNIQUE (Jours, Debut, Fin),
    CONSTRAINT Debut_avant_fin CHECK (Debut <= Fin)
);

CREATE TABLE Exception
(
    Id serial PRIMARY KEY,
    Nom varchar,
    Planning varchar NOT NULL,
    Ajoute boolean NOT NULL,
    DateDebut date NOT NULL,
    DateFin date,
    CONSTRAINT Planning_fkey FOREIGN KEY (Planning)
    REFERENCES Planning (Nom) MATCH SIMPLE,
    CONSTRAINT DateDebut_DateFin_key UNIQUE (Planning, DateDebut, DateFin),
    CONSTRAINT Nom_key UNIQUE (Nom, Planning),
    CONSTRAINT DateDebutInferieurDateFin CHECK (DateDebut<=DateFin),
    CONSTRAINT Id_diff_0 CHECK (Id <> 0)
);

CREATE TABLE Trajet
(
    Id serial PRIMARY KEY,
    Ligne integer NOT NULL,
    HeureDepart time without time zone NOT NULL,
    HeureArrivee time without time zone NOT NULL,
    PrixPrem numeric(5,2),
    PrixSec numeric(5,2) NOT NULL,
    Planning varchar,
    CONSTRAINT Pas_deux_departs_en_mm_tmps UNIQUE (HeureArrivee, Ligne),
    CONSTRAINT Pas_deux_arrivees_en_mm_tmps UNIQUE (HeureDepart, Ligne),
    CONSTRAINT Ligne_fkey FOREIGN KEY (Ligne)
    REFERENCES Ligne (Id) MATCH SIMPLE,
    CONSTRAINT Planning_fkey FOREIGN KEY (Planning)
    REFERENCES Planning (Nom) MATCH SIMPLE,
    CONSTRAINT Arrivee_apres_depart CHECK (HeureDepart < HeureArrivee),
    CONSTRAINT PrixSec_pos CHECK (PrixSec > 0),
    CONSTRAINT PrixPrem_pos CHECK (PrixPrem > 0),
    CONSTRAINT Id_diff_0 CHECK (Id <> 0)
);

CREATE TABLE Voyageur
(
    Id serial PRIMARY KEY,
    Nom varchar NOT NULL,
    Prenom varchar NOT NULL,
    NumeroTel numeric(10,0),
    TypeVoyageur StatutVoyageur NOT NULL,
    NumeroCarte numeric(12,0),
    Adresse Adresse,
    Ville varchar,
    CONSTRAINT Ville_fkey FOREIGN KEY (Ville)
    REFERENCES Ville (Nom) MATCH SIMPLE,
    CONSTRAINT Nom_prenom_adresse_ville_key UNIQUE (Nom, Prenom, Adresse, Ville),
    CONSTRAINT NumeroCarte_key UNIQUE (NumeroCarte),
    CONSTRAINT NumeroTel_key UNIQUE (NumeroTel),
    CONSTRAINT Id_diff_0 CHECK (Id <> 0)
);

CREATE TABLE Reservation
(
    Id serial PRIMARY KEY,
    Voyageur integer NOT NULL,
    Assurance boolean NOT NULL,
    MoyenPaiement MoyenPaiement NOT NULL,
    CONSTRAINT Voyageur_fkey FOREIGN KEY (Voyageur)
    REFERENCES Voyageur (Id) MATCH SIMPLE,
    CONSTRAINT Id_diff_0 CHECK (Id <> 0)
);

CREATE TABLE Billet
(
    Id serial PRIMARY KEY,
    Trajet integer NOT NULL,
    Date date NOT NULL,
    Classe Classe NOT NULL,
    Place integer,
    Annule boolean NOT NULL,
    Reservation integer NOT NULL,
    CONSTRAINT Reservation_fkey FOREIGN KEY (Reservation)
    REFERENCES Reservation (Id) MATCH SIMPLE,
    CONSTRAINT Trajet_fkey FOREIGN KEY (Trajet)
    REFERENCES Trajet (Id) MATCH SIMPLE,
    CONSTRAINT Trajet_date_place_key UNIQUE (Trajet, Date, Place),
    CONSTRAINT Place_pos CHECK (Place > 0),
    CONSTRAINT Id_diff_0 CHECK (Id <> 0)
);

CREATE TABLE Gerants
{
	login varchar NOT NULL PRIMARY KEY,
	mdp varchar NOT NULL
};



CREATE OR REPLACE FUNCTION areExceptionsOverlaping(
    DateDebu Date,
    DateFin_ Date
)
RETURNS int
LANGUAGE 'plpgsql'
AS $BODY$

DECLARE
Result int;
BEGIN
Result:=0;
IF EXISTS(SELECT * FROM Exception e WHERE NOT ((e.DateDebut<DateDebu and e.DateFin<DateDebu) or (e.DateDebut>DateFin_ and e.DateFin > DateFin_))) THEN
Result := 1;
END IF;
RETURN Result;
END
$BODY$;

ALTER TABLE Exception
ADD CONSTRAINT overlapingExceptions
CHECK (areExceptionsOverlaping(DateDebut,DateFin) = 0);
