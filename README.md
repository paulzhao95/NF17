# NF17
Projet Société de Chemins de Fer.

## Installation

```
cd ~/public_html # Pour installer à la racine de votre dossier web
git clone https://github.com/bertille-ddp/NF17
cp model/db_info.php_example model/db_info.php
vim model/db_info.php # N'importe quel autre éditeur de texte fonctionne aussi
# Remplir db_info.php avec les informations de connexion à la BDD
# Créer les schémas de base de données en exécutant sql/database.sql
# Préremplir la BDD en exécutant sql/populate.sql
```

## MCD

![UML](https://raw.githubusercontent.com/bertille-ddp/NF17/master/uml/MCD.png)

## Note de clarification
Plop


## MLD

```
Gare(#Nom: string, #Ville: string, Adresse: string, ZoneHoraire: string)
Hotel(#NomH: string, #Ville=>Gare.Ville, Adresse: string, NomG=>Gare.Nom, PrixNuit: unsigned integer) avec (Adresse, Ville) clé
TyeTrain(#Nom: string, nbPlacesPrem: unsigned integer, nbPlacesSec: unsigned integer, vitesseMax: unsigned integer)
Ligne(#Numero: unsigned integer, NomGareDep=>Gare.Nom, VilleGareDep=>Gare.Ville, NomGareArr=>Gare.Nom, VilleGareArr=>Gare.Ville, ModeleTrain=>TypeTrain.Nom) avec (NomGareDep, VilleGareDep, NomGareArr, VilleGareArr, ModeleTrain) clé
Planning(#Nom: string, Lundi: boolean, Mardi: boolean, Mercredi: boolean, Jeudi: boolean, Vendredi: boolean, Samedi: boolean, Dimanche: boolean) avec (Lundi, Mardi, Mercredi, Jeudi, Vendredi, Samedi, Dimanche) clé
Exception(#Id: unsigned integer, Nom: string, Planning=>Planning.Nom, Ajoute: boolean, DateDebut: date, DateFin: date) avec (Planning, DateDebut, DateFin) clé et (Nom, Planning) clé
Trajet(#Numero: unsigned int, Ligne=>Ligne.Numero, HeureDepart: time, HeureArrivee: time, PrixPrem: float, PrixSec: float, Planning=>Planning.nom) avec (HeureDepart, Ligne) et (HeureArrivee, Ligne) clés
Voyageur(#Id: unsigned int, Nom: string, Prenom: string, NumeroTel: numeric, TypeVoyageur: string{'Occasionnel', 'Argent', 'Or', 'Platine'}, NumeroCarte: numeric, Adresse: string, Ville: string) avec (Nom, Prenom, Adresse, Ville) clé
Reservation(#Numero: unsigned int, Voyageur=>Voyageur.id, Assurance: boolean, MoyenPaiement: string{'CB', 'Chèque', 'Espèces'})
Billet(#Numero: int, Trajet=>Trajet.Numero, Date: date, Classe: int{1, 2}, Place: unsigned int, Annule: boolean, Reservation=>Reservation.Numero) avec (Trajet, Date, Place) clé
```

### Contraintes d'intégrité
* `NomGareDep` et `VilleGareDep` doivent référencer un même enregistrement de Gare.
* Idem pour `NomGareArr` et `VilleGareArr`.
* `Exception.DateDebut` doit être inférieure à `Exception.DateFin`.
* Il ne peut y avoir dans la table `Exception` deux entrées qui se superposent pour un même planning.
* `Trajet.HeureDepart` doit être inférieure à `Trajet.HeureArrivee`.
* `Trajet.PrixPrem` et `Trajet.PrixSec` sont positifs.
* `Billet.Place` doit être inférieur au nombre total de places disponibles dans ce type de train.

### Dépendances fonctionnelles
#TODO

## Product backlog
