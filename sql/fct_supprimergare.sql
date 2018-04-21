CREATE OR REPLACE FUNCTION "supprimerTrajet"(
    idTrajet integer)
RETURNS boolean
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    billets_a_annuler integer[];
    billet integer;
    existe boolean;
BEGIN
    SELECT INTO existe EXISTS (SELECT "Id"         -- on vérifie que le trajet existe
    FROM "Trajet"
    WHERE "Id" = idTrajet);

    IF NOT existe THEN                -- sinon on quitte
        RAISE EXCEPTION 'Train % non trouvé.', idTrajet;
    END IF;

    SELECT INTO billets_a_annuler array_agg("Id")        -- on sélectionne les billets liés à ce trajet
    FROM "Billet"
    WHERE "Trajet" = idTrajet;

    FOREACH billet IN ARRAY billets_a_annuler LOOP
        IF (SELECT "Date" FROM "Billet" WHERE "Id" = billet) > CURRENT_DATE THEN
            PERFORM "annulerBillet"(billet);           -- on les annule pour rembourser les usagers
        END IF;
        DELETE FROM "Billet"                       -- et on les supprime pour ne pas avoir de données incohérentes
        WHERE "Id" = billet;
    END LOOP;

    DELETE FROM "Trajet"
    WHERE "Id" = idTrajet;

    RETURN TRUE;
END
$BODY$;

CREATE OR REPLACE FUNCTION "supprimerLigne"(
    idLigne integer)
RETURNS boolean
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    trajets_a_supprimer integer[];
    trajet integer;
    existe boolean;
BEGIN
    SELECT INTO existe EXISTS (SELECT "Id"         -- on vérifie que la ligne existe
    FROM "Ligne"
    WHERE "Id" = idLigne);

    IF NOT existe THEN                -- sinon on quitte
        RAISE EXCEPTION 'La ligne numéro % n''existe pas.', idLigne;
    END IF;

    SELECT INTO trajets_a_supprimer array_agg("Id")        -- on sélectionne les trajets liés à cette ligne
    FROM "Trajet"
    WHERE "Ligne" = idLigne;

    FOREACH trajet IN ARRAY trajets_a_supprimer LOOP
        PERFORM "supprimerTrajet"(trajet);           -- on les supprime proprement pour ne pas avoir de données incohérentes
    END LOOP;

    DELETE FROM "Ligne"
    WHERE "Id" = idLigne;           -- et on supprime la ligne

    RETURN TRUE;
END
$BODY$;

CREATE OR REPLACE FUNCTION "supprimerGare"(
    nom varchar,
    ville varchar)
RETURNS boolean
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    lignes_a_supprimer integer[];
    ligne integer;
    existe boolean;
BEGIN
    SELECT INTO existe EXISTS (SELECT "Nom"         -- on vérifie que la gare existe
    FROM "Gare"
    WHERE "Nom" = nom AND "Ville" = ville);

    IF NOT existe THEN                -- sinon on quitte
        RAISE EXCEPTION '% n''existe pas.', nom;
    END IF;

    SELECT INTO lignes_a_supprimer array_agg("Id")        -- on sélectionne les lignes liées à cette gare
    FROM "Ligne"
    WHERE ("NomGareDep" = nom AND "VilleGareDep" = ville)
    OR ("NomGareArr" = nom AND "VilleGareArr" = ville);

    FOREACH ligne IN ARRAY lignes_a_supprimer LOOP
        PERFORM "supprimerLigne"(ligne);           -- on les supprime proprement pour ne pas avoir de données incohérentes
    END LOOP;

    DELETE FROM "Gare"
    WHERE "Nom" = nom AND "Ville" = ville;  -- et on supprime la gare

    RETURN TRUE;
END
$BODY$;
