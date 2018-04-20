CREATE OR REPLACE FUNCTION "trouverLigne"(   -- fonction qui renvoie un tableau des lignes allant de VilleD à VilleA
	VilleD varchar,
	VilleA varchar)
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

	IF lignes_ok IS NULL THEN              -- si le tableau est vide c'est que le query n'a pas trouvé de ligne entre ces villes
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
    SELECT array_agg("Planning") INTO plannings_pasok     -- les plannings qui sont concernés par une exception annulante à la date demandée devront être exclus du résultat
	FROM "Exception"
	WHERE "DateDebut" <= jour
	AND "DateFin" >= jour
	AND "Ajoute" = false;

    jour_semaine := extract(isodow from jour);

    SELECT array_agg("Nom") INTO plannings_ok
    FROM "Planning"
    WHERE "Jours"[jour_semaine] = true         -- le numéro du jour de la semaine donne la case du tableau à vérifier
    AND (plannings_pasok IS NULL OR NOT "Nom" = ANY(plannings_pasok))  -- on exclut les plannings trouvés plus haut
    AND ("Debut" IS NULL OR "Debut" <= jour)      -- il faut que le planning couvre le jour sélectionné
    AND ("Fin" IS NULL OR "Fin" >= jour);

    SELECT array_agg("Planning") INTO plannings_ajoutes  -- il faut trouver les exceptions qui ajoutent des trajets
    FROM "Exception"
    WHERE "DateDebut" <= jour
    AND "DateFin" >= jour
    AND "Ajoute" = true;

    SELECT array_cat(plannings_ok, plannings_ajoutes) INTO plannings_ok;  -- le résultat final est la concaténation des plannings exceptionnels et des plannings qui marchent ce jour de la semaine

	IF plannings_ok IS NULL THEN
	   RAISE EXCEPTION 'Aucun train planifie le %.', jour;
	END IF;

	RETURN plannings_ok;
END
$BODY$;


CREATE OR REPLACE FUNCTION "trouverTrajet"(
	VilleD varchar,
	VilleA varchar,
	jour date)
RETURNS TABLE(num_trajet integer,              -- le type de retour sera une table avec toutes les informations qui intéressent l'utilisateur, c'est la fonction destinée à être affichée
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
    WHERE "Trajet"."Ligne" = ANY("trouverLigne"(VilleD, VilleA))       -- on se sert des fonctions précédentes pour afficher les trajets qui correspondent au souhait de l'utilisateur
	AND "Trajet"."Planning" = ANY("trouverPlanning"(jour));
END
$BODY$;
