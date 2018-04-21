CREATE OR REPLACE FUNCTION "prixBillet"(
    idBillet integer)
RETURNS numeric
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    billet "Billet"%ROWTYPE;
    prix numeric(5,2);
BEGIN
    SELECT * INTO billet         -- on récupère les informations du billet
    FROM "Billet" b
    WHERE b."Id" = idBillet;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Billet % non trouvé', idBillet;
    END IF;

    IF billet."Classe" = '1' THEN    -- le prix est extrait des informations du trajet
        SELECT INTO prix "PrixPrem"
        FROM "Billet" INNER JOIN "Trajet"
        ON "Billet"."Trajet" = "Trajet"."Id";
    ELSE
        SELECT INTO prix "PrixSec"
        FROM "Billet" INNER JOIN "Trajet"
        ON "Billet"."Trajet" = "Trajet"."Id";
    END IF;
    RETURN prix;
END
$BODY$;

CREATE OR REPLACE FUNCTION "montantRemboursementBillet"(
    idBillet integer)
RETURNS numeric
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    billet "Billet"%ROWTYPE;
    assurance boolean;
BEGIN
    SELECT * INTO billet          -- on récupère les informations du billet
    FROM "Billet" b
    WHERE b."Id" = idBillet;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Billet % non trouvé', idBillet;
    END IF;

    IF billet."Date" < CURRENT_DATE THEN       -- on ne peut annuler le billet que si la date n'est pas encore passée
        RAISE EXCEPTION 'Billet % expiré', idBillet;
    END IF;

    IF billet."Annule" THEN                   -- le billet ne doit pas déjà être annulé
        RAISE EXCEPTION 'Billet % déjà remboursé', idBillet;
    END IF;

    SELECT INTO assurance "Reservation"."Assurance"     -- on cherche si le voyageur avait pris une assurance au moment de la réservation
    FROM "Billet" INNER JOIN "Reservation"
    ON "Billet"."Reservation" = "Reservation"."Id";

    IF assurance THEN           -- le montant à remboursé est calculé à partir de là
        RETURN "prixBillet"(idBillet);
    ELSE
        RETURN "prixBillet"(idBillet)*0.80;
    END IF;
END
$BODY$;

CREATE OR REPLACE FUNCTION "rembourserClient"(
    idVoyageur integer,
    montant numeric)
RETURNS boolean
    LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    -- cette fonction est factice, dans un vrai système, c'est là que les instructions pour créditer le compte bancaire du client seraient données
    RETURN true;
END
$BODY$;

CREATE OR REPLACE FUNCTION "annulerBillet"(  -- fonction finale
    idBillet integer)
RETURNS boolean
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    idVoyageur integer;
    montant numeric;
BEGIN
    montant := "montantRemboursementBillet"(idBillet);

    SELECT INTO idVoyageur "Voyageur"
    FROM "Reservation" INNER JOIN "Billet"
    ON "Reservation"."Id" = "Billet"."Reservation"
    WHERE "Billet"."Id" = idBillet;

    IF NOT "rembourserClient"(idVoyageur,montant) THEN -- on vérifie que le remboursement a pu se faire
        RETURN false;
    END IF;

    UPDATE "Billet"  -- si oui, on enregistre que le bilet a été annulé et on libère la place
    SET "Annule" = true, "Place" = NULL
    WHERE "Billet"."Id" = idBillet;

    RETURN true;
END
$BODY$;
