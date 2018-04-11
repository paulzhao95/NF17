CREATE OR REPLACE FUNCTION "trouverLigne"(
	villed varchar,
	villea varchar)
RETURNS integer[]
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    lignes_ok integer[];

BEGIN
    SELECT array_agg("Id") INTO lignes_ok
    FROM "Ligne"
    WHERE "VilleGareDep" = VilleD
    AND "VilleGareArr" = VilleA;

    IF array_length(lignes_ok, 1) <= 0 THEN
        RAISE EXCEPTION 'Pas de train entre % et %.', VilleD, VilleA;
    END IF;

    RETURN lignes_ok;
END
$BODY$;

CREATE OR REPLACE FUNCTION "trouverPlanning"(
	jour date)
RETURNS integer[]
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    jour_semaine integer;
    plannings_ok integer[];

BEGIN
    jour_semaine := extract(isodow from jour);
    
    CASE jour_semaine
    WHEN 1 THEN
        SELECT array_agg("Id") INTO plannings_ok
        FROM "Planning"
        WHERE "Lundi" = true;
        
    WHEN 2 THEN
        SELECT array_agg("Id") INTO plannings_ok
        FROM "Planning"
        WHERE "Mardi" = true;
        
    WHEN 3 THEN
        SELECT array_agg("Id") INTO plannings_ok
        FROM "Planning"
        WHERE "Mercredi" = true;
        
    WHEN 4 THEN
        SELECT array_agg("Id") INTO plannings_ok
        FROM "Planning"
        WHERE "Jeudi" = true;
        
    WHEN 5 THEN
        SELECT array_agg("Id") INTO plannings_ok
        FROM "Planning"
        WHERE "Vendredi" = true;
        
    WHEN 6 THEN
        SELECT array_agg("Id") INTO plannings_ok
        FROM "Planning"
        WHERE "Samedi" = true;
        
    WHEN 7 THEN
        SELECT array_agg("Id") INTO plannings_ok
        FROM "Planning"
        WHERE "Dimanche" = true;
        
    END CASE;
    
    IF array_length(plannings_ok, 1) <= 0 THEN
        RAISE EXCEPTION 'Aucun train planifie le %.', jour;
    END IF;
    
    RETURN plannings_ok;
END
$BODY$;

CREATE OR REPLACE FUNCTION "trouverTrajet"(
	villeD varchar,
	villeA varchar,
	jour date)
RETURNS TABLE(num_trajet integer,
    gare_dep varchar, 
    heure_dep time without time zone, 
    gare_arr varchar,
    heure_arr time without time zone, 
    prix_sec integer, 
    prix_prem integer,
    train varchar) 
    LANGUAGE 'plpgsql'
AS $BODY$

BEGIN
    RETURN QUERY SELECT "Trajet"."Id", "NomGareDep", "HeureDepart", "NomGareArr", "HeureArrivee", "PrixSec", "PrixPrem", "TypeTrain"
    FROM "Trajet" INNER JOIN "Ligne"
    ON "Trajet"."Ligne" = "Ligne"."Id"
    WHERE "Trajet"."Ligne" = ANY("trouverLigne"(villeD, villeA))
    AND "Trajet"."Planning" = ANY("trouverPlanning"(jour));
END
$BODY$;
