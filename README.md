# Mini-projet Bases de données 1 — Gestion d’événements de MMA

**Binôme :** Ayoub El Azzouzi et Chraf Eddine Guidouche

## 1. Présentation

Ce projet consiste à concevoir une base de données relationnelle pour gérer une organisation d’événements de MMA. Elle permet de suivre les combattants, leurs performances et licences, les combats, les arbitres, les événements, la billetterie, les spectateurs, les médias et les sponsors.

## 2. Modèles de données

Le modèle conceptuel des données (MCD) et le modèle logique des données (MLD) sont fournis dans le dépôt :

- `mcd.png` — modèle conceptuel des données ;
- `mld.png` — modèle logique des données.

Les clés primaires sont indiquées par `PK` et les clés étrangères par `FK`.

### MLD

- **organisation** (`ID_organisation` PK, Nom_organisation, Email_organisation)
- **arbitre** (`ID_arbitre` PK, Nom_arbitre, Prénom_arbitre, Nationalité)
- **combattant** (`Combattant_ID` PK, Prénom_combattant, Nom_combattant, Date_de_naissance, Nationalité, Catégorie_de_poids, Statut_médical, Dernier_certificat_médical)
- **licence** (`Numéro_Licence_Sportive` PK, Date_délivrance, Date_expiration, `ID_organisation` FK, `Combattant_ID` FK)
- **performance** (`ID_performance` PK, Nombre_de_victoires, Nombre_de_défaites, Nombre_de_matchs_nuls, Nombre_de_victoires_par_ko, Nombre_de_victoires_par_soumission, `Combattant_ID` FK)
- **media** (`ID_media` PK, Nom_media, Type_media)
- **combat** (`ID_combat` PK, Résultat_combat, Durée_combat, Poids_autorisé, `ID_arbitre` FK)
- **évènement** (`ID_évènement` PK, Nom_évènement, Date_évènement, Lieu_évènement, `ID_media` FK, `ID_combat` FK, `ID_organisation` FK)
- **spectateur** (`Téléphone_spectateur` PK, Nom_spectateur, Prénom_spectateur, Email_spectateur)
- **billet** (`ID_billet` PK, Catégorie_billet, Prix_billet, `ID_évènement` FK, `Téléphone_spectateur` FK, `ID_organisation` FK)
- **sponsor** (`ID_Sponsor` PK, Nom_sponsor, Type_de_sponsoring, Montant_sponsoring, Début_contrat_sponsor, Fin_contrat_sponsor)
- **participe** (`Combattant_ID` PK, FK ; `ID_combat` PK, FK)
- **est_obligatoire** (`Numéro_Licence_Sportive` PK, FK ; `ID_combat` PK, FK)
- **finance** (`ID_évènement` PK, FK ; `ID_Sponsor` PK, FK)

Les tables `participe`, `est_obligatoire` et `finance` représentent des associations plusieurs-à-plusieurs à l’aide de clés primaires composées.

## 3. Modèle physique et scripts SQL

Le modèle physique est implémenté en SQL dans la base `mma_event_db`. Il comprend 14 tables, avec des clés primaires, des clés étrangères et des contraintes d’intégrité.

Les fichiers SQL s’exécutent dans cet ordre :

1. `1_creation.sql` — création du schéma et des tables ;
2. `2_contraintes.sql` — ajout des contraintes de validation ;
3. `3_insertion.sql` — insertion des données de démonstration ;
4. `4_interrogation.sql` — exécution des requêtes.

Les scripts utilisent la syntaxe MySQL. Les données de démonstration servent à tester le schéma et les requêtes. Si elles ont été générées par une IA et que l’énoncé exige le prompt utilisé, celui-ci doit être ajouté au dépôt.

> **Attention :** avant de réexécuter le script de création, vérifier s’il supprime les tables existantes. Conserver une copie des données à préserver.

## 4. Contraintes d’intégrité

Les contraintes ajoutées contrôlent notamment la validité de certaines valeurs et la cohérence des données, par exemple :

- le statut médical et la catégorie de poids ;
- le prix des billets et le montant du sponsoring ;
- la cohérence des dates de licence et de contrat ;
- les valeurs des statistiques de performance ;
- les références entre les tables.

Les règles de suppression et de mise à jour des clés étrangères sont définies dans les scripts SQL.

## 5. Scénario d’utilisation

La base répond aux besoins de plusieurs rôles dans une organisation d’événements de MMA :

- **Direction sportive :** consulter les performances, vérifier les licences et le statut médical, préparer les combats et suivre les arbitres.
- **Gestion financière et marketing :** suivre la billetterie et les sponsors, et consulter les informations relatives aux événements et aux médias.

## 6. Requêtes SQL

Le fichier `4_interrogation.sql` contient 20 requêtes d’exploitation de la base. Elles couvrent notamment les filtres et tris, les agrégations, les jointures et les sous-requêtes.

La requête Q20 recherche les nom, prénom et nombre de victoires des combattants français ayant plus de 10 victoires et disposant d’une licence enregistrée :

    SELECT c.Nom_combattant, c.Prénom_combattant, p.Nombre_de_victoires
    FROM combattant AS c
    JOIN performance AS p
      ON c.Combattant_ID = p.Combattant_ID
    JOIN licence AS l
      ON c.Combattant_ID = l.Combattant_ID
    WHERE c.Nationalité = 'France'
      AND p.Nombre_de_victoires > 10;

## 7. Optimisation théorique de la requête Q20

Une optimisation classique consiste à appliquer les filtres avant les jointures, afin de réduire les lignes qui participent à celles-ci :

    π(Nom_combattant, Prénom_combattant, Nombre_de_victoires)
    (
      (σ(Nationalité = 'France')(combattant))
      ⋈ performance
      ⋈ licence
    )
    avec le filtre Nombre_de_victoires > 10 appliqué à performance

Selon les cardinalités estimées, on suppose que :

- `combattant` contient 1 000 lignes, dont 100 combattants français ;
- `performance` contient 1 000 lignes, dont 200 combattants ayant plus de 10 victoires ;
- `licence` contient 1 000 lignes.

Ces chiffres sont des hypothèses pour illustrer le principe. Une estimation de 20 résultats supposerait notamment une répartition indépendante des critères et une correspondance adéquate entre les enregistrements. **Le nombre réel de résultats doit être vérifié avec les données chargées dans la base.**

Pousser les filtres au plus près des tables peut réduire le volume intermédiaire des jointures. Cependant, les sommes de lignes proposées dans un calcul simplifié ne représentent pas le nombre réel d’opérations ou le coût exact d’exécution de MySQL. Pour analyser les performances, exécuter `EXPLAIN` sur la requête et commenter le plan obtenu sur l’installation utilisée.

## 8. Vérifications avant la remise

Avant de rendre le projet :

- exécuter les quatre scripts SQL dans l’ordre ;
- vérifier que le MLD correspond aux tables et aux relations du SQL ;
- relever et commenter le plan réel de la requête Q20 ;
- compléter les informations manquantes demandées dans l’énoncé.

