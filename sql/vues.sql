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
