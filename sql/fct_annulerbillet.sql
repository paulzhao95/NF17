CREATE OR REPLACE FUNCTION "prixBillet"(
    idBillet integer)
RETURNS numeric
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    billet "Billet"%ROWTYPE;
    prix numeric(5,2);
BEGIN
    SELECT * INTO billet FROM "Billet" b WHERE b."Id" = idBillet;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Billet % non trouvé', idBillet;
    END IF;

    IF billet."Classe" = '1' THEN
        SELECT INTO prix "PrixPrem" FROM "Billet" INNER JOIN "Trajet" ON "Billet"."Trajet" = "Trajet"."Id";
    ELSE
        SELECT INTO prix "PrixSec" FROM "Billet" INNER JOIN "Trajet" ON "Billet"."Trajet" = "Trajet"."Id";
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
    SELECT * INTO billet FROM "Billet" b WHERE b."Id" = idBillet;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Billet % non trouvé', idBillet;
    END IF;
    IF billet."Date" < CURRENT_DATE THEN
        RAISE EXCEPTION 'Billet % expiré', idBillet;
    END IF;
    IF billet."Annule" THEN
        RAISE EXCEPTION 'Billet % déjà remboursé', idBillet;
    END IF;
    SELECT INTO assurance "Reservation"."Assurance" FROM "Billet" INNER JOIN "Reservation" ON "Billet"."Reservation" = "Reservation"."Id";
    IF assurance THEN
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
    --ON NE PEUT PAS FAIRE CETTE FONCTION POUR L'INSTANT
    RETURN true;
END
$BODY$;

CREATE OR REPLACE FUNCTION "annulerBillet"(
    idBillet integer)
RETURNS boolean
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    idVoyageur integer;
    montant numeric;
BEGIN
    montant := "montantRemboursementBillet"(idBillet);
    SELECT INTO idVoyageur "Voyageur" FROM "Reservation" INNER JOIN "Billet" ON "Reservation"."Id" = "Billet"."Reservation" WHERE "Billet"."Id" = idBillet;
    IF NOT "rembourserClient"(idVoyageur,montant) THEN
        RETURN false;
    END IF;
    UPDATE "Billet" SET "Annule" = true WHERE "Billet"."Id" = idBillet;
    RETURN true;
END
$BODY$;
