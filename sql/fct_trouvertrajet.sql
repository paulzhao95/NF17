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

	IF lignes_ok IS NULL <= 0 THEN
	RAISE EXCEPTION 'Pas de train entre % et %.', VilleD, VilleA;
	END IF;

	RETURN lignes_ok;
END
$BODY$;


CREATE OR REPLACE FUNCTION "trouverPlanning"(
	jour date)
RETURNS varchar[]
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
	jour_semaine integer;
	plannings_ok varchar[];
    plannings_ajoutes varchar[];
	plannings_pasok varchar[];

BEGIN
	jour_semaine := extract(isodow from jour);

    SELECT array_agg("Planning") INTO plannings_pasok
	FROM "Exception"
	WHERE "DateDebut" <= jour
	AND "DateFin" >= jour
	AND "Ajoute" = false;

	CASE jour_semaine
	WHEN 1 THEN
    	SELECT array_agg("Nom") INTO plannings_ok
    	FROM "Planning"
    	WHERE "Lundi" = true
    	AND (plannings_pasok IS NULL OR NOT "Nom" = ANY(plannings_pasok));

	WHEN 2 THEN
    	SELECT array_agg("Nom") INTO plannings_ok
    	FROM "Planning"
    	WHERE "Mardi" = true
    	AND (plannings_pasok IS NULL OR NOT "Nom" = ANY(plannings_pasok));

	WHEN 3 THEN
    	SELECT array_agg("Nom") INTO plannings_ok
    	FROM "Planning"
    	WHERE "Mercredi" = true
    	AND (plannings_pasok IS NULL OR NOT "Nom" = ANY(plannings_pasok));

	WHEN 4 THEN
    	SELECT array_agg("Nom") INTO plannings_ok
    	FROM "Planning"
    	WHERE "Jeudi" = true
    	AND (plannings_pasok IS NULL OR NOT "Nom" = ANY(plannings_pasok));

	WHEN 5 THEN
    	SELECT array_agg("Nom") INTO plannings_ok
    	FROM "Planning"
    	WHERE "Vendredi" = true
    	AND (plannings_pasok IS NULL OR NOT "Nom" = ANY(plannings_pasok));

	WHEN 6 THEN
    	SELECT array_agg("Nom") INTO plannings_ok
    	FROM "Planning"
    	WHERE "Samedi" = true
    	AND (plannings_pasok IS NULL OR NOT "Nom" = ANY(plannings_pasok));

	WHEN 7 THEN
    	SELECT array_agg("Nom") INTO plannings_ok
    	FROM "Planning"
    	WHERE "Dimanche" = true
    	AND (plannings_pasok IS NULL OR NOT "Nom" = ANY(plannings_pasok));
	END CASE;

    SELECT array_agg("Planning") INTO plannings_ajoutes
    FROM "Exception"
    WHERE "DateDebut" <= jour
    AND "DateFin" >= jour
    AND "Ajoute" = true;

    SELECT array_cat(plannings_ok, plannings_ajoutes) INTO plannings_ok;

	IF plannings_ok IS NULL THEN
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
