CREATE OR REPLACE VIEW "Incoherence_place_premiere" AS      -- cette vue renvoie les billets pris en premiere classe dans un train qui n'a que la seconde classe
    SELECT "Billet"."Id"
    FROM "Billet" INNER JOIN "Trajet"
    ON "Billet"."Trajet" = "Trajet"."Id"
    INNER JOIN "Ligne"
    ON "Trajet"."Ligne" = "Ligne"."Id"
    INNER JOIN "TypeTrain"
    ON "Ligne"."TypeTrain" = "TypeTrain"."Nom"
    WHERE "Classe" = '1'
    AND "nbPlacesPrem" = 0
;

CREATE OR REPLACE VIEW "Incoherence_prix_premiere" AS      -- cette vue renvoie les trajets qui indiquent un prix pour la première classe alors que le train n'a que la seconde classe
    SELECT "Trajet"."Id"
    FROM "Trajet" INNER JOIN "Ligne"
    ON "Trajet"."Ligne" = "Ligne"."Id"
    INNER JOIN "TypeTrain"
    ON "Ligne"."TypeTrain" = "TypeTrain"."Nom"
    WHERE "PrixPrem" IS NOT NULL
    AND "nbPlacesPrem" = 0
;

CREATE OR REPLACE VIEW "Incoherence_date_billet" AS      -- cette vue renvoie les billets pris pour des jours où le train en question ne circule pas
    SELECT "Billet"."Id"
    FROM "Billet" INNER JOIN "Trajet"
    ON "Billet"."Trajet" = "Trajet"."Id"
    WHERE "Trajet"."Planning" NOT IN (SELECT * FROM unnest("trouverPlanning"("Billet"."Date")))
;

CREATE OR REPLACE VIEW "FrequentationLignes" AS         -- vue pour obtenir des statistiques sur la fréquentation de chaque ligne
    SELECT COUNT("Billet"."Id") AS Frequentation, "VilleGareDep" AS Depart, "VilleGareArr" AS Arrivee
	FROM "Billet" INNER JOIN "Trajet"
	ON "Billet"."Trajet" = "Trajet"."Id"
    INNER JOIN "Ligne"
    ON "Trajet"."Ligne" = "Ligne"."Id"
    WHERE "Billet"."Annule" = false
    GROUP BY Depart, Arrivee
    ORDER BY Frequentation DESC;

CREATE OR REPLACE VIEW "FrequentationGares" AS         -- vue pour obtenir des statistiques sur la fréquentation de chaque ligne
    SELECT COUNT("Billet"."Id") AS Frequentation, "Gare"."Nom" AS Nom, "Gare"."Ville" AS Ville
	FROM "Billet" INNER JOIN "Trajet"
    ON "Billet"."Trajet" = "Trajet"."Id"
    INNER JOIN "Ligne"
    ON "Trajet"."Ligne" = "Ligne"."Id"
    INNER JOIN "Gare"
    ON ("Ligne"."NomGareDep" = "Gare"."Nom" AND "Ligne"."VilleGareDep" = "Gare"."Ville")
    OR ("Ligne"."NomGareArr" = "Gare"."Nom" AND "Ligne"."VilleGareArr" = "Gare"."Ville")
    WHERE "Billet"."Annule" = false
    GROUP BY Nom, Ville
    ORDER BY Frequentation DESC;
