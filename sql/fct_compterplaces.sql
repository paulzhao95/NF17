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
