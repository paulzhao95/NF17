DROP FUNCTION annulerBillet(integer);
DROP FUNCTION rembourserClient(integer, numeric);
DROP FUNCTION montantRemboursementBillet(integer);
DROP FUNCTION prixBillet(integer);

DROP FUNCTION reserverBillet(integer, integer, boolean, MoyenPaiement, integer, Date, Classe);
DROP FUNCTION updateStatut(integer);
DROP FUNCTION genereCarte();
DROP FUNCTION placesRestantes(integer, Date);

DROP FUNCTION trouverTrajet(varchar, varchar, Date);
DROP FUNCTION trouverPlanning(Date);
DROP FUNCTION trouverLigne(varchar, varchar);

DROP FUNCTION supprimerGare(varchar, varchar);
DROP FUNCTION supprimerLigne(integer);
DROP FUNCTION supprimerTrajet(integer);


DROP TYPE adresse CASCADE;
DROP TYPE classe CASCADE;
DROP TYPE MoyenPaiement CASCADE;
DROP TYPE StatutVoyageur CASCADE;

DROP TABLE gare CASCADE;
DROP TABLE billet CASCADE;
DROP TABLE exception CASCADE;
DROP TABLE hotel CASCADE;
DROP TABLE ligne CASCADE;
DROP TABLE planning CASCADE;
DROP TABLE reservation CASCADE;
DROP TABLE trajet CASCADE;
DROP TABLE typetrain CASCADE;
DROP TABLE ville CASCADE;
DROP TABLE voyageur CASCADE;
DROP TABLE gerants CASCADE;


DROP FUNCTION areexceptionsoverlaping(date, date);
