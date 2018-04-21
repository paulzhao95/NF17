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
    nouveau_numero numeric(12,0);

BEGIN
    SELECT INTO nouveau_numero floor(random()*1000000000000);  -- le numéro doit être compris entre 0 et 1 000 000 000 000 pour avoir 12 chiffres

    IF EXISTS (SELECT "NumeroCarte" FROM "Voyageur" WHERE "NumeroCarte" = nouveau_numero) THEN
        SELECT INTO nouveau_numero "genereCarte"();  -- si le numéro tiré est déjà attribué, on appelle à nouveau la fonction
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


CREATE OR REPLACE FUNCTION "reserverBillet"(                -- on réserve des billets pour un même trajet
	nbBillet integer,
	voyageur integer,
	assurance boolean,
	moyenPaiement "MoyenPaiement",
	trajetID integer,
	dt Date,
	cl "Classe")
RETURNS integer[]
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    max_places integer;
	num_re integer;
    places_attribuees integer[];
    place integer;
    i integer;
BEGIN
    IF cl = '1' THEN
        SELECT INTO max_places placesPrem             -- on cherche combien de places libres il reste dans le train
        FROM "placesRestantes"(trajetID, dt);
    ELSE
        SELECT INTO max_places placesSec
        FROM "placesRestantes"(trajetID, dt);
    END IF;

    IF max_places < nbBillet THEN
        RAISE EXCEPTION 'Il ne reste plus assez de place dans le train % du %.', trajetID, dt;
    END IF;

    INSERT INTO "Reservation" ("Voyageur", "Assurance", "MoyenPaiement") VALUES
    (voyageur, assurance, moyenPaiement);  -- on crée d'abord la réservation

    SELECT INTO num_re "Id"  -- on trouve son numéro
    FROM "Reservation"
    ORDER BY "Id" DESC LIMIT 1;

    IF cl = '1' THEN                                   -- on trouve la borne sup du numéro de place qu'on pourra affecter
        SELECT INTO max_places "nbPlacesPrem"
        FROM "Trajet" INNER JOIN "Ligne"
        ON "Trajet"."Ligne" = "Ligne"."Id"
        INNER JOIN "TypeTrain"
        ON "Ligne"."TypeTrain" = "TypeTrain"."Nom"
        WHERE "Trajet"."Id" = trajetID;
    ELSE
        SELECT INTO max_places "nbPlacesSec"
        FROM "Trajet" INNER JOIN "Ligne"
        ON "Trajet"."Ligne" = "Ligne"."Id"
        INNER JOIN "TypeTrain"
        ON "Ligne"."TypeTrain" = "TypeTrain"."Nom"
        WHERE "Trajet"."Id" = trajetID;
    END IF;

	FOR i IN 1..nbBillet LOOP                       -- pour chaque billet à prendre
        SELECT INTO place floor(random()*max_places);  -- on tire un numéro de place inférieur à la borne sup

        WHILE EXISTS (SELECT "Place" FROM "Billet" WHERE "Trajet" = trajetID AND "Date" = dt AND "Place" = place) LOOP -- on vérifie qu'il n'est pas déjà attribué
            SELECT INTO place floor(random()*max_places);
        END LOOP;

        SELECT INTO places_attribuees array_append(places_attribuees, place);  -- on construit le tableau des places atribuées

		INSERT INTO "Billet" ("Trajet", "Date", "Classe", "Place", "Annule", "Reservation") VALUES
        (trajetID, dt, cl, places_attribuees[i], false, num_re);  -- on insère les valeurs dans la table
	END LOOP;

    IF NOT "updateStatut"(voyageur) THEN        -- on met à jour jour le statut du voyageur (qui passe peut-être or avec cette nouvelle réservation)
        RAISE EXCEPTION 'Erreur à la mise à jour du statut du voyageur %.', voyageur;
    END IF;

    RETURN places_attribuees;        -- on renvoie les places prises
END
$BODY$;
