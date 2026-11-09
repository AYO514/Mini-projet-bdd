# Mini-projet Bases de Données — Gestion d’événements de MMA

**Réalisé par :** Ayoub El Azzouzi et Chraf Eddine Guidouche

## Présentation du projet

Ce projet couvre la conception et l’implémentation d’une base de données relationnelle destinée à la gestion d’événements de MMA.

Il suit les étapes du projet de base de données : définition du besoin, modélisation conceptuelle (MCD), modélisation logique (MLD), création des tables, ajout des contraintes, insertion de données et interrogation de la base.

Le système permet de gérer les organisations, combattants, licences sportives, performances, combats, arbitres, événements, médias, spectateurs, billets et sponsors.

## Scénario d’utilisation

Une organisation prépare un événement de MMA. Elle enregistre les combattants et leurs licences, consulte leurs performances, programme les combats et leur attribue des arbitres. Elle associe également l’événement à un média et à des sponsors.

Pour la billetterie, elle enregistre les spectateurs et les billets liés aux événements. La base permet ensuite de consulter, par exemple, les performances des combattants, les combats arbitrés, les recettes des billets et les contributions des sponsors.

## Modélisation de la base

### Modèle conceptuel des données (MCD)

Le MCD présente les entités du domaine, leurs attributs et leurs associations. Il constitue le point de départ de la conception de la base.

![Modèle conceptuel des données — MCD](mcd.png)

### Modèle logique des données (MLD)

Le MLD traduit la modélisation conceptuelle en relations, clés primaires et clés étrangères.

![Modèle logique des données — MLD](mld.png)

### Principales relations

| Domaine | Tables | Rôle |
|---|---|---|
| Organisation sportive | `organisation`, `combattant`, `licence`, `performance` | Identifier les organisations et suivre les combattants, leurs licences et leurs résultats |
| Déroulement sportif | `combat`, `arbitre`, `participe`, `est_obligatoire` | Décrire les combats, leurs arbitres, leurs participants et les licences associées |
| Événements et diffusion | `évènement`, `media` | Planifier les événements et renseigner les médias |
| Billetterie | `spectateur`, `billet` | Associer les billets aux événements et aux spectateurs |
| Financement | `sponsor`, `finance` | Associer les sponsors aux événements |

Les tables `participe`, `est_obligatoire` et `finance` représentent des associations au moyen de clés primaires composées.

## Implémentation SQL

La base est implémentée avec la syntaxe **MySQL**. Le script de création définit **14 tables**, leurs clés primaires et leurs clés étrangères. Le script suivant ajoute des contraintes de validation métier.

| Fichier du dépôt | Contenu |
|---|---|
| `mcd.png` | Modèle conceptuel des données |
| `mld.png` | Modèle logique des données |
| `1_creation (2).sql` | Suppression éventuelle des tables existantes et création des 14 tables |
| `2_contraintes.sql` | Ajout de contraintes de validation |
| `3_insertion (1).sql` | Insertion des données de démonstration |
| `4_interrogation.sql` | Vingt requêtes de consultation et d’analyse |

Les contraintes portent notamment sur le statut médical, les catégories de poids, le prix des billets, les montants de sponsoring, la cohérence des dates, la durée des combats et les statistiques de performance. Les clés étrangères assurent les liens entre les tables.

## Installation et exécution

### Prérequis

- Un serveur MySQL compatible avec les instructions `CHECK` utilisées par les scripts.
- Le client en ligne de commande `mysql`, ou un outil permettant d’exécuter des fichiers SQL.
- Une connexion avec les droits nécessaires pour créer une base et des tables.

### Créer la base

Les scripts `2_contraintes.sql` et `3_insertion (1).sql` sélectionnent la base `mma` avec `USE mma;`. Créer cette base avant l’exécution :

~~~sql
CREATE DATABASE IF NOT EXISTS mma
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
~~~

### Exécuter les scripts

Depuis le dossier du projet, lancer les fichiers dans cet ordre :

~~~bash
mysql -u root -p mma < "1_creation (2).sql"
mysql -u root -p mma < "2_contraintes.sql"
mysql -u root -p mma < "3_insertion (1).sql"
mysql -u root -p mma < "4_interrogation.sql"
~~~

Remplacer `root` par votre utilisateur MySQL si nécessaire.

**Attention :** `1_creation (2).sql` contient des instructions `DROP TABLE IF EXISTS`. Le relancer supprime les tables du projet et les données qu’elles contiennent. Le script d’insertion est destiné à être exécuté après la création des tables, pas plusieurs fois de suite sur les mêmes données.

## Données de démonstration

Le jeu de données de `3_insertion (1).sql` sert à illustrer le fonctionnement de la base et à tester les requêtes. Il comprend des exemples d’organisations, de combattants, de performances, de licences, de combats, d’événements, de spectateurs, de billets et de sponsors.

Ces données sont des **données de démonstration** : elles ne constituent pas un registre sportif officiel.

## Requêtes et exploitation

`4_interrogation.sql` contient **20 requêtes**, réparties entre :

- des sélections, filtres et tris ;
- des calculs et agrégations avec `GROUP BY` et `HAVING` ;
- des jointures entre tables ;
- des sous-requêtes ;
- une requête retenue pour l’étude de l’optimisation relationnelle.

Ces requêtes permettent notamment de rechercher des combattants selon différents critères, de calculer des recettes de billetterie, d’étudier les performances sportives et de croiser les informations des événements avec celles des autres tables.

## Étude d’optimisation : requête Q20

Q20 recherche les combattants français ayant plus de dix victoires et une licence enregistrée :

~~~sql
SELECT c.Nom_combattant,
       c.Prénom_combattant,
       p.Nombre_de_victoires
FROM combattant AS c
JOIN performance AS p
  ON c.Combattant_ID = p.Combattant_ID
JOIN licence AS l
  ON c.Combattant_ID = l.Combattant_ID
WHERE c.Nationalité = 'France'
  AND p.Nombre_de_victoires > 10;
~~~

### Comparaison théorique des plans

Un **plan naïf** joint d’abord les tables `combattant`, `performance` et `licence`, puis applique les filtres. Il peut ainsi produire et parcourir davantage de lignes intermédiaires.

Un **plan optimisé** cherche à appliquer au plus tôt les conditions `Nationalité = 'France'` et `Nombre_de_victoires > 10`, avant de joindre les résultats filtrés. Cette transformation correspond à la **poussée des sélections** en algèbre relationnelle.

Les calculs fondés sur des tables hypothétiques de 1 000 lignes illustrent cette idée, mais **ne décrivent pas le jeu de données réellement inséré** et ne mesurent pas le coût réel d’exécution. Le plan choisi par MySQL peut être examiné avec :

~~~sql
EXPLAIN
SELECT c.Nom_combattant,
       c.Prénom_combattant,
       p.Nombre_de_victoires
FROM combattant AS c
JOIN performance AS p
  ON c.Combattant_ID = p.Combattant_ID
JOIN licence AS l
  ON c.Combattant_ID = l.Combattant_ID
WHERE c.Nationalité = 'France'
  AND p.Nombre_de_victoires > 10;
~~~

L’analyse du résultat doit porter sur l’ordre d’accès aux tables, les index utilisés et les estimations de lignes. Aucun temps d’exécution ou gain de performance mesuré n’est affirmé sans exécution effective.

## Correspondance entre les modèles et l’implémentation

Les diagrammes documentent la conception du projet ; les scripts SQL décrivent son implémentation actuelle. Certaines différences doivent être prises en compte lors de la lecture des modèles :

- le MLD illustré montre `ID_performance` dans `organisation`, tandis que le SQL relie directement `performance` à `combattant` et ne crée pas cette colonne dans `organisation` ;
- le SQL contient des attributs supplémentaires pour plusieurs tables, notamment les noms d’organisations, d’arbitres et de médias ;
- le SQL relie également `évènement` à `organisation`.

Pour utiliser la base, **les tables réellement créées par `1_creation (2).sql` font référence**. Les diagrammes peuvent être mis à jour si une correspondance exacte entre conception et implémentation est exigée.

## Limites du projet

- Le projet fournit une base de données et des requêtes SQL, mais pas d’interface utilisateur.
- Les données insérées servent aux démonstrations et aux tests.
- Toutes les règles métier ne peuvent pas être garanties par les contraintes actuellement présentes ; par exemple, la base n’impose pas à elle seule exactement deux participants pour chaque combat.
- Le plan d’exécution et les performances dépendent des données et de l’environnement MySQL utilisés.
