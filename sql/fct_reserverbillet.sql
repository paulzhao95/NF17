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
    SELECT "nbPlacesPrem" INTO places_total1  -- query pour compter les places qu'offre un trajet donné
    FROM "Trajet" INNER JOIN "Ligne"
    ON "Trajet"."Ligne" = "Ligne"."Id"
    INNER JOIN "TypeTrain"
    ON "Ligne"."TypeTrain" = "TypeTrain"."Nom"  -- il faut donc aller chercher le type de train
    WHERE "Trajet"."Id" = numTrain;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Le train numéro % n''existe pas.', numTrain;
    END IF;

    SELECT COUNT("Id") INTO places_prises1  -- on compte les billets pris pour ce trajet au jour donné, dans la classe donnée et qui n'ont pas été annulés
    FROM "Billet"
    WHERE "Trajet" = numTrain
    AND "Date" = jour
    AND "Classe" = '1'
    AND "Annule" = false;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Le train numéro % ne roule pas le %.', numTrain, jour;
    END IF;

    SELECT "nbPlacesSec" INTO places_total2  -- idem pour la seconde classe
    FROM "Trajet" INNER JOIN "Ligne"
    ON "Trajet"."Ligne" = "Ligne"."Id"
    INNER JOIN "TypeTrain"
    ON "Ligne"."TypeTrain" = "TypeTrain"."Nom"
    WHERE "Trajet"."Id" = numTrain;

    SELECT COUNT("Id") INTO places_prises2
    FROM "Billet"
    WHERE "Trajet" = numTrain
    AND "Date" = jour
    AND "Classe" = '2'
    AND "Annule" = false;

    RETURN QUERY SELECT places_total1-places_prises1, places_total2-places_prises2;  -- on retourne les soustractions

END
$BODY$;

CREATE OR REPLACE FUNCTION "genereCarte"()  -- fonction pour générer un numéro de carte
RETURNS numeric(12,0)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    numero_existants numeric(12,0)[];
    nouveau_numero numeric(12,0);

BEGIN
    SELECT INTO numero_existants array_agg("NumeroCarte")  -- pour pouvoir vérifier l'unicité, on sélectionne les numéros déjà attribués
    FROM "Voyageur";

    SELECT INTO nouveau_numero floor(random()*1000000000000);  -- le numéro doit être compris entre 0 et 1 000 000 000 000 pour avoir 12 chiffres

    IF nouveau_numero = any(numero_existants) THEN  -- si le numéro tiré est déjà attribué, on appelle à nouveau la fonction
        SELECT INTO nouveau_numero "genereCarte"();
    ELSE
        RETURN nouveau_numero;  -- on retourne ensuite le nouveau numéro
    END IF;

END
$BODY$;

CREATE OR REPLACE FUNCTION "updateStatut"(  -- fonction pour mettre à jour le statut d'un voyageur donné
    idVoyageur integer)
RETURNS boolean
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    nb_billets integer;
    numero_carte_actuel numeric(12,0);
    numero_carte_nouveau numeric(12,0);

BEGIN
    SELECT INTO nb_billets COUNT("Billet"."Id")  -- on compte combien de billets il a pris
    FROM "Reservation" INNER JOIN "Billet"
    ON "Reservation"."Id" = "Billet"."Reservation"
    WHERE "Reservation"."Voyageur" = idVoyageur
    AND "Billet"."Annule" = false;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Le voyageur % n''est pas dans la base.', idVoyageur;
    END IF;

    CASE           -- selon le nombre, on lui accorde un statut donné
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

    SELECT INTO numero_carte_actuel "NumeroCarte"  -- on trouve ensuite son numéro de carte pour éviter les incohérences
    FROM "Voyageur"
    WHERE "Id" = idVoyageur;

    IF numero_carte_actuel IS NULL THEN
        SELECT INTO numero_carte_nouveau *     -- s'il n'en a pas, on lui en génère un
        FROM "genereCarte"();

        UPDATE "Voyageur"       -- et on lui met
        SET "NumeroCarte" = numero_carte_nouveau
        WHERE "Id" = idVoyageur
        AND "TypeVoyageur" <> 'Occasionnel';

    ELSE
        UPDATE "Voyageur"        -- s'il en a un alors que c'est un voyageur occasionnel, on lui supprime
        SET "NumeroCarte" = NULL
        WHERE "Id" = idVoyageur
        AND "TypeVoyageur" = 'Occasionnel';
    END IF;

    RETURN true;  -- tout s'est bien passé

END
$BODY$;
