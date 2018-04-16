CREATE OR REPLACE FUNCTION "placesRestantes"(
    numTrain integer,
    jour date)
RETURNS TABLE(
    placesPrem integer,
    placesSec integer)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    places_total1 integer;
    places_prises1 integer;
    places_total2 integer;
    places_prises2 integer;

BEGIN
    SELECT "nbPlacesPrem" INTO places_total1
    FROM "Trajet" INNER JOIN "Ligne"
    ON "Trajet"."Ligne" = "Ligne"."Id"
    INNER JOIN "TypeTrain"
    ON "Ligne"."TypeTrain" = "TypeTrain"."Nom"
    WHERE "Trajet"."Id" = numTrain;

    SELECT COUNT("Id") INTO places_prises1
    FROM "Billet"
    WHERE "Trajet" = numTrain
    AND "Date" = jour
    AND "Classe" = '1';

    SELECT "nbPlacesSec" INTO places_total2
    FROM "Trajet" INNER JOIN "Ligne"
    ON "Trajet"."Ligne" = "Ligne"."Id"
    INNER JOIN "TypeTrain"
    ON "Ligne"."TypeTrain" = "TypeTrain"."Nom"
    WHERE "Trajet"."Id" = numTrain;

    SELECT COUNT("Id") INTO places_prises2
    FROM "Billet"
    WHERE "Trajet" = numTrain
    AND "Date" = jour
    AND "Classe" = '2';

    RETURN QUERY SELECT places_total1-places_prises1, places_total2-places_prises2;

END
$BODY$;

CREATE OR REPLACE FUNCTION "genereCarte"()
RETURNS numeric(12,0)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    numero_existants numeric(12,0)[];
    nouveau_numero numeric(12,0);

BEGIN
    SELECT INTO numero_existants array_agg("NumeroCarte")
    FROM "Voyageur";

    SELECT INTO nouveau_numero floor(random()*(1000000000000));

    IF nouveau_numero = any(numero_existants) THEN
        SELECT INTO nouveau_numero "genereCarte"();
    ELSE
        RETURN nouveau_numero;
    END IF;

END
$BODY$;

CREATE OR REPLACE FUNCTION "updateStatut"(
    idVoyageur integer)
RETURNS boolean
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    nb_billets integer;
    numero_carte_actuel numeric(12,0);
    numero_carte_nouveau numeric(12,0);

BEGIN
    SELECT INTO nb_billets COUNT("Billet"."Id")
    FROM "Reservation" INNER JOIN "Billet"
    ON "Reservation"."Id" = "Billet"."Reservation"
    WHERE "Reservation"."Voyageur" = idVoyageur
    AND "Billet"."Annule" = false;

    CASE
    WHEN nb_billets < 10 THEN
        UPDATE "Voyageur"
        SET "TypeVoyageur" = 'Occasionnel'
        WHERE "Id" = idVoyageur;

    WHEN nb_billets >= 10 AND nb_billets < 25 THEN
        UPDATE "Voyageur"
        SET "TypeVoyageur" = 'Argent'
        WHERE "Id" = idVoyageur;

    WHEN nb_billets >= 25 AND nb_billets < 50 THEN
        UPDATE "Voyageur"
        SET "TypeVoyageur" = 'Or'
        WHERE "Id" = idVoyageur;

    WHEN nb_billets >= 50 THEN
        UPDATE "Voyageur"
        SET "TypeVoyageur" = 'Platine'
        WHERE "Id" = idVoyageur;
    END CASE;

    SELECT INTO numero_carte_actuel "NumeroCarte"
    FROM "Voyageur"
    WHERE "Id" = idVoyageur;

    IF numero_carte_actuel IS NULL THEN
        SELECT INTO numero_carte_nouveau *
        FROM "genereCarte"();

        UPDATE "Voyageur"
        SET "NumeroCarte" = numero_carte_nouveau
        WHERE "Id" = idVoyageur
        AND "TypeVoyageur" <> 'Occasionnel';

    ELSE
    UPDATE "Voyageur"
        SET "NumeroCarte" = NULL
        WHERE "Id" = idVoyageur
        AND "TypeVoyageur" = 'Occasionnel';
    END IF;

    RETURN true;

END
$BODY$;
