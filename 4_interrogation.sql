use mma;	
-- Q1: Combattants français pesant plus de 70kg, triés par nom
SELECT DISTINCT Prénom_combattant, Nom_combattant, Catégorie_de_poids 
FROM combattant 
WHERE Nationalité = 'France' AND Catégorie_de_poids IN ('Poids Léger', 'Poids Mi-Moyen', 'Poids Moyen', 'Poids Mi-Lourd', 'Poids Lourd')
ORDER BY Nom_combattant ASC;

-- Q2: Billets dont le prix est compris entre 100€ et 300€
SELECT ID_billet, Catégorie_billet, Prix_billet 
FROM billet 
WHERE Prix_billet BETWEEN 100.00 AND 300.00;

-- Q3: Recherche des spectateurs avec une adresse email chez Gmail ou Yahoo (avec masque LIKE)
SELECT Nom_spectateur, Prénom_spectateur, Email_spectateur 
FROM spectateur 
WHERE Email_spectateur LIKE '%@gmail.com' OR Email_spectateur LIKE '%@email.com';

-- Q4: Liste des sponsors ayant investi au moins 200 000€
SELECT Nom_sponsor, Type_de_sponsoring, Montant_sponsoring 
FROM sponsor 
WHERE Montant_sponsoring >= 200000.00
ORDER BY Montant_sponsoring DESC;

-- Q5: Combattants nés entre 1990 et 1998
SELECT Prénom_combattant, Nom_combattant, Date_de_naissance 
FROM combattant 
WHERE Date_de_naissance BETWEEN '1990-01-01' AND '1998-12-31';


-- ------------------------------------------------------------
-- CATEGORIE 2 : Fonctions d'agrégation, GROUP BY et HAVING (5 requêtes)
-- ------------------------------------------------------------

-- Q6: Nombre total de combattants par nationalité ayant au moins 2 combattants
SELECT Nationalité, COUNT(*) AS Nombre_Combattants 
FROM combattant 
GROUP BY Nationalité 
HAVING COUNT(*) >= 2;

-- Q7: Recette totale et prix moyen des billets vendus par évènement
SELECT ID_évènement, SUM(Prix_billet) AS Recette_Totale, AVG(Prix_billet) AS Prix_Moyen 
FROM billet 
GROUP BY ID_évènement;

-- Q8: Nombre total de victoires par KO par catégorie de poids pour les catégories ayant plus de 5 KOs cumulés
SELECT c.Catégorie_de_poids, SUM(p.Nombre_de_victoires_par_ko) AS Total_KO 
FROM combattant c 
JOIN performance p ON c.Combattant_ID = p.Combattant_ID 
GROUP BY c.Catégorie_de_poids 
HAVING SUM(p.Nombre_de_victoires_par_ko) >= 3;

-- Q9: Montant moyen apporté par les sponsors par type de sponsoring ayant plus de 150 000€ en moyenne
SELECT Type_de_sponsoring, AVG(Montant_sponsoring) AS Sponsor_Moyen 
FROM sponsor 
GROUP BY Type_de_sponsoring 
HAVING AVG(Montant_sponsoring) > 150000.00;

-- Q10: Nombre de combats arbitrés par chaque arbitre ayant arbitré au moins 1 combat
SELECT a.Nom_arbitre, a.Prénom_arbitre, COUNT(c.ID_combat) AS Total_Combats 
FROM arbitre a 
JOIN combat c ON a.ID_arbitre = c.ID_arbitre 
GROUP BY a.ID_arbitre, a.Nom_arbitre, a.Prénom_arbitre;


-- ------------------------------------------------------------
-- CATEGORIE 3 : Jointures internes, externes, multiples (5 requêtes)
-- ------------------------------------------------------------

-- Q11: Liste des combats avec le nom de l'arbitre et le lieu de l'événement (Jointure multiple)
SELECT e.Nom_évènement, e.Lieu_évènement, c.Résultat_combat, CONCAT(a.Prénom_arbitre, ' ', a.Nom_arbitre) AS Arbitre 
FROM évènement e 
JOIN combat c ON e.ID_combat = c.ID_combat 
JOIN arbitre a ON c.ID_arbitre = a.ID_arbitre;

-- Q12: Liste de tous les combattants et leur nombre de victoires (LEFT JOIN pour conserver les combattants sans fiche perf)
SELECT c.Prénom_combattant, c.Nom_combattant, COALESCE(p.Nombre_de_victoires, 0) AS Victoires 
FROM combattant c 
LEFT JOIN performance p ON c.Combattant_ID = p.Combattant_ID;

-- Q13: Détail des billets vendus avec les infos du spectateur et de l'événement
SELECT b.ID_billet, b.Catégorie_billet, b.Prix_billet, e.Nom_évènement, s.Nom_spectateur, s.Téléphone_spectateur 
FROM billet b 
JOIN évènement e ON b.ID_évènement = e.ID_évènement 
JOIN spectateur s ON b.Téléphone_spectateur = s.Téléphone_spectateur;

-- Q14: Sponsors associés à chaque événement (Jointure N-N via la table finance)
SELECT e.Nom_évènement, sp.Nom_sponsor, sp.Montant_sponsoring 
FROM évènement e 
JOIN finance f ON e.ID_évènement = f.ID_évènement 
JOIN sponsor sp ON f.ID_Sponsor = sp.ID_Sponsor;

-- Q15: Combattants ayant participé à un combat et l'événement associé
SELECT c.Prénom_combattant, c.Nom_combattant, e.Nom_évènement, cb.Résultat_combat 
FROM combattant c 
JOIN participe pt ON c.Combattant_ID = pt.Combattant_ID 
JOIN combat cb ON pt.ID_combat = cb.ID_combat 
JOIN évènement e ON cb.ID_combat = e.ID_combat;


-- ------------------------------------------------------------
-- CATEGORIE 4 : Requêtes imbriquées (IN, EXISTS, ANY, ALL) (5 requêtes)
-- ------------------------------------------------------------

-- Q16: Combattants n'ayant JAMAIS participé à aucun combat dans la table participe (NOT IN)
SELECT Prénom_combattant, Nom_combattant 
FROM combattant 
WHERE Combattant_ID NOT IN (SELECT Combattant_ID FROM participe);

-- Q17: Événements sponsorisés par au moins un sponsor avec un financement supérieur à 200 000€ (EXISTS)
SELECT Nom_évènement, Lieu_évènement 
FROM évènement e 
WHERE EXISTS (
    SELECT 1 FROM finance f 
    JOIN sponsor s ON f.ID_Sponsor = s.ID_Sponsor 
    WHERE f.ID_évènement = e.ID_évènement AND s.Montant_sponsoring > 200000.00
);

-- Q18: Combattants ayant un nombre de victoires supérieur à ALL (tous) les combattants de la catégorie 'Poids Mouche'
SELECT c.Prénom_combattant, c.Nom_combattant, p.Nombre_de_victoires 
FROM combattant c 
JOIN performance p ON c.Combattant_ID = p.Combattant_ID 
WHERE p.Nombre_de_victoires > ALL (
    SELECT p2.Nombre_de_victoires 
    FROM combattant c2 
    JOIN performance p2 ON c2.Combattant_ID = p2.Combattant_ID 
    WHERE c2.Catégorie_de_poids = 'Poids Mouche'
);

-- Q19: Spectateurs ayant acheté un billet d'un prix supérieur à ANY (au moins un) billet acheté de catégorie 'Catégorie 2'
SELECT DISTINCT s.Nom_spectateur, s.Prénom_spectateur 
FROM spectateur s 
JOIN billet b ON s.Téléphone_spectateur = b.Téléphone_spectateur 
WHERE b.Prix_billet > ANY (
    SELECT Prix_billet FROM billet WHERE Catégorie_billet = 'Catégorie 2'
);

-- Q20: REQUÊTE POUR L'ÉTUDE DU PLAN D'EXÉCUTION (Optimisation Relationnelle)
-- Recherche des combattants français ayant obtenu plus de 10 victoires et enregistrés dans une organisation
SELECT c.Nom_combattant, c.Prénom_combattant, p.Nombre_de_victoires 
FROM combattant c 
JOIN performance p ON c.Combattant_ID = p.Combattant_ID 
JOIN licence l ON c.Combattant_ID = l.Combattant_ID 
WHERE c.Nationalité = 'France' AND p.Nombre_de_victoires > 10;
