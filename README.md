# Projet Société de Chemins de Fer

## Installation

```
cd ~/public_html # Pour installer à la racine de votre dossier web
git clone https://github.com/bertille-ddp/NF17
cp model/db_info.php_example model/db_info.php
vim model/db_info.php # N'importe quel autre éditeur de texte fonctionne aussi
# Remplir db_info.php avec les informations de connexion à la BDD
# Créer les schémas de base de données en exécutant sql/database.sql
# Préremplir la BDD en exécutant sql/populate.sql
# Implémenter les fonctionnalités en exécutant sql/fct_*
# Vérifier que les données sont cohérentes en important les vues de sql/vues.sql
```

## Note de clarification
### Contexte du projet
La SCF nous demande de mettre en place un système pour gérer ses gares, ses lignes, ses trains et la planification des trajets. Elle veut qu’il soit accessible aussi pour ses usager⋅e⋅s afin de réserver des billets et de consulter les hôtels à proximité de la gare d’arrivée, entre autres besoins. De plus, elle veut pouvoir obtenir par le biais de ce système des statistiques sur les trajets réservés grâce à celui-ci.

### Objectifs et livrables de l’étude
Nous proposons de construire une base de données pour formaliser et stocker les informations nécessaires à la bonne marche de ce système. Nous livrerons aussi une application de démonstration qui permet d’interroger cette base de données de façon sûre et intuitive. Les requêtes passées par cette interface permettront d’enrichir la base de données en ajoutant des informations mais aussi de modifier ou de supprimer celles-ci et de les afficher ou de les agréger pour en faire des statistiques.

### Moyens mis en œuvre
Ces moyens sont avant tout humains. À cette note de clarification est joint un *product backlog* qui renseigne la quantité de travail nécessaire pour aboutir au système attendu.

### Détails du système
#### Liste de classes
La SCF nous a indiqué ses besoins en termes de gares, de trains et de voyageurs. Pour pouvoir implémenter ces entités dans une base de données, il faut relever ce qui les identifie et quelles informations sont pertinentes. Ainsi, nous avons vu que les éléments suivants sont plus riches en informations et ne dépendent d’aucun autre :
* les gares ;
* les types de trains ;
* les voyageur⋅euse⋅s.
Comme toutes les gares ont, selon l’énoncé de la SCF, un nom, une adresse, une ville et une zone horaire, on peut créer un patron de gare, une Idée de gare au sens de Platon. C’est une classe dont on créera plusieurs instances que la SCF renseignera.

La SCF veut aussi pouvoir manipuler d’autres types d’objets, qui sont définis à partir de ceux renseignés ci-dessus. Ce sont :
* les lignes (définies par l’association entre deux gares et un type de train accepté) ;
* les trajets (qui associent à une ligne un sens, des horaires, un prix et un numéro) ;
* un planning (une fréquence dans la semaine sur une période donnée qui s’applique à un ou des trajets) ;
* les réservations (des conteneurs qui regroupent plusieurs billets achetés en même temps et par le même moyen de paiement par un⋅e même usager⋅e) ;
* les billets (qui associent une date, une classe et une place à un trajet et qui font partie d'une réservation).
Ce sont aussi des classes puisqu’on veut pouvoir en créer plusieurs instances toutes calquées sur un modèle bien précis, mais elles sont dérivées des premières et reposent sur des associations avec celles-ci ou avec les premières classes secondaires de la liste.

#### Choix techniques
Lors du recueil des besoins, la SCF a laissé entendre que tous ses trains étaient sans arrêt. Nous nous appuierons sur cette donnée pour définir simplement une ligne en tant qu'association entre une gare de départ et une gare d'arrivée.

La SCF voulait pouvoir changer les plannings des trains sur des jours spéciaux. Nous considérons que ces jours sont spéciaux pour tous les trajets et que ce sont donc les plannings qui sont modifiés. Si l’exception supprime une date, aucun des trajets reliés à ce planning n’aura lieu à cette date. Si elle ajoute une date, les trajets seront effectués même si cette date est en-dehors de la période ou tombe un jour de la semaine où ce trajet n’est pas effectué normalement. Avec ces choix, pour définir un trajet exceptionnel sur des horaires différents, il faut créer un trajet pour cet horaire, y associer un planning vide et les dates d’exception concernées.

La SCF souhaite qu'un⋅e usager⋅e puisse annuler son billet ou le modifier pour partir à un autre jour. Nous considérons qu'une telle modification est en faite la suite d'une annulation et de la commande d'un autre billet. Nous ne prévoyons donc pas de fonctionnalité particulière.

Pour éviter d'avoir des données redondantes, et puisqu'une ville ne peut être dans deux fuseaux horaires différents, nous créerons aussi une table pour les villes. De cette façon, deux gares desservant une même ville ne pourront avoir des zones horaires différentes.

Enfin, et même si cela sort des prérogatives de la SCF, nous avons intégré les hôtels à notre modèle. Ce sont simplement l’association d’une adresse, d’un prix pour la nuit et d’une gare de référence. Cela étant, les taxis et les informations sur les transports publics changent trop rapidement, la SCF ne pourra pas les maintenir. Nous jugeons que les intégrer ne serait pas pertinent ou même possible dans une base de données.
Si notre système contient toutes les informations listées ci-dessus, il est alors possible de déployer les fonctions souhaitées par la SCF à savoir :
* tenue à jour des gares, lignes, trains et itinéraire pour leur usage interne ;
* consultation des horaires, recherche de trajets, réservation ou annulation de billets pour les usager⋅e⋅s ;
* calcul de statistiques sur les trains, pour toutes les personnes intéressées.

## Product backlog
|Rendu	|Priorité	|Tâches	|No de semaine	|Temps de travail   |
|-------|-----------|-------|---------------|-------------------|
|P1	|1	|Définition des fonctions et des classes requises	                                    |1	|2  |
|	|2	|Rédaction de la note de clarification.	                                                |1	|1  |
|	|3	|Élaboration du product backlog.	                                                    |1	|1  |
|	|4	|Création du modèle conceptuel de données.	                                            |1	|2  |
|P2	|5	|Transformation du MCD en MLD.                                                          |2	|2,5|
|P3	|6	|Création d’une base de données.                                                        |3  |1  |
|	|7	|Création des tables avec les attributs repérés dans le MLD.	                        |3	|1  |
|	|8	|Ajout des contraintes sur les données.                                                 |3	|1  |
|	|9	|Ajout de données dans les tables en vue de tests.                                      |3	|2  |
|	|10	|Test du fonctionnement de la BDD                                                       |3	|2  |
|	|11	|Création des requêtes pour consulter les trajets correspondant aux besoin des usagers.	|4	|3  |
|	|12	|Création des requêtes pour réserver un billet.                                         |4	|2  |
|	|13	|Test des requêtes créées.	                                                            |4	|2  |
|	|14	|Création des requêtes pour supprimer des gares, types de trains, lignes, trains et trajets.	|5	|2    |
|	|15	|Création des requêtes pour modifier ou annuler un billet.	                            |5	|3  |
|	|16	|Création des requêtes pour s’assurer que le train ne se remplit pas au-delà de sa capacité.	|5	|2    |
|	|17	|Création des requêtes pour mettre à jour le statut des voyageurs.	                    |6	|2  |
|	|18	|Création des requêtes pour la gestion des dates d'exception.	                        |6	|3  |
|	|19	|Création des requêtes pour empêcher ou faire payer les modifications de billets.	    |6	|3  |
|	|20	|Création des requêtes pour afficher les hôtels à proximité.	                        |7	|2  |
|	|21	|Création les requêtes pour obtenir des statistiques sur le fonctionnement de la société.	|7	|4   |
|	|22	|Test des requêtes créées.	                                                            |7	|2  |
|P4	|23	|Étude des bases de donné non-relationnelles.	                                        |8 et 9   |   |
|	|24	|Création de la base de données non-relationnelles.	                                    |9 à 11   |   |
|	|25	|Test de la base de données créée.                                                      |11	|4  |
|P5	|26	|Création de l’interface pour la SCF.	                                                |12	|5  |
|	|27	|Création de l’interface pour l’utilisateur.	                                        |12	|6  |
|	|28	|Création de l’interface de statistiques.	                                            |13	|4  |
|	|29	|Test des interfaces.	                                                                |13	|4  |
|	|30	|Finalisation et soumission des applications.	                                        |13	|2  |


## Modèle conceptuel de données
Des besoins de la SCF et des interprétations que nous avons explicitées ci-dessus, nous avons construit le modèle de données suivant :
![UML](https://raw.githubusercontent.com/bertille-ddp/NF17/master/uml/MCD.png)

## Modèle logique de données
Il se traduit en un ensemble de tables, que nous pourront créer dans la base de données.

Nous avons souligné les attributs non clés qui doivent être non nuls.
```markdown
Ville(#Nom: string, CP: integer, __ZoneHoraire__: integer) avec CP clé
Gare(#Nom: string, #Ville=>Ville.Nom, __Adresse__: string)
Hotel(#NomH: string, #Ville=>Gare.Ville, __Adresse__: string, __NomG__=>Gare.Nom, PrixNuit: unsigned integer) avec (Adresse, Ville) clé
TyeTrain(#Nom: string, __nbPlacesPrem__: unsigned integer, __nbPlacesSec__: unsigned integer, __vitesseMax__: unsigned integer)
Ligne(#Numero: unsigned integer, NomGareDep=>Gare.Nom, VilleGareDep=>Gare.Ville, NomGareArr=>Gare.Nom, VilleGareArr=>Gare.Ville, ModeleTrain=>TypeTrain.Nom) avec (NomGareDep, VilleGareDep, NomGareArr, VilleGareArr, ModeleTrain) clé
Planning(#Nom: string, Jours: boolean array, Debut: date, Fin: date) avec (Jours, Debut, Fin) unique
Exception(#Id: unsigned integer, Nom: string, Planning=>Planning.Nom, Ajoute: boolean, DateDebut: date, DateFin: date) avec (Planning, DateDebut, DateFin) clé et (Nom, Planning) clé
Trajet(#Numero: unsigned int, Ligne=>Ligne.Numero, HeureDepart: time, HeureArrivee: time, PrixPrem: float, __PrixSec__: float, __Planning__=>Planning.nom) avec (HeureDepart, Ligne) et (HeureArrivee, Ligne) clés
Voyageur(#Id: unsigned int, Nom: string, Prenom: string, NumeroTel: numeric, __TypeVoyageur__: string{'Occasionnel', 'Argent', 'Or', 'Platine'}, NumeroCarte: numeric, Adresse: string, Ville: string) avec (Nom, Prenom, Adresse, Ville) clé et NumeroCarte et NumeroTel uniques s'ils existent
Reservation(#Numero: unsigned int, __Voyageur__=>Voyageur.id, __Assurance__: boolean, __MoyenPaiement__: string{'CB', 'Chèque', 'Espèces'})
Billet(#Numero: int, Trajet=>Trajet.Numero, Date: date, __Classe__: int{1, 2}, Place: unsigned int, Annule: boolean, Reservation=>Reservation.Numero) avec (Trajet, Date, Place) clé
```

### Contraintes d'intégrité
* `NomGareDep` et `VilleGareDep` doivent référencer un même enregistrement de `Gare`.
* Idem pour `NomGareArr` et `VilleGareArr`.
* `NomGareDep` et `NomGareArr` référencent deux enregistrements différents de `Gare`.
* `Planning.Jours` comporte sept cases.
* `Planning.Debut` doit être inférieur à `Planning.Fin`.
* `Exception.DateDebut` doit être inférieure à `Exception.DateFin`.
* Il ne peut y avoir dans la table `Exception` deux entrées qui se superposent pour un même planning.
* `Trajet.HeureDepart` doit être inférieure à `Trajet.HeureArrivee`.
* `Trajet.PrixPrem` et `Trajet.PrixSec` sont positifs.
* `Billet.Place` doit être inférieur au nombre total de places disponibles dans ce type de train.

### Dépendances fonctionnelles
#TODO
