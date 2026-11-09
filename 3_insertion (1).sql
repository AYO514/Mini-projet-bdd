use mma;
-- 1. Organisations
INSERT INTO organisation (ID_organisation, Nom_organisation, Email_organisation) VALUES
(1, 'UFC Paris Chapter', 'contact@ufcparis.com'),
(2, 'PFL Europe', 'info@pfleurope.com'),
(3, 'KSW International', 'support@kswmma.com'),
(4, 'Ares Fighting Championship', 'contact@aresmma.com'),
(5, 'Hexagone MMA', 'admin@hexagonemma.fr');

-- 2. Arbitres
INSERT INTO arbitre (ID_arbitre, Nom_arbitre, Prénom_arbitre, Nationalité) VALUES
(1, 'Goddard', 'Marc', 'Royaume-Uni'),
(2, 'Dean', 'Herb', 'États-Unis'),
(3, 'Beltran', 'Mike', 'États-Unis'),
(4, 'Berghman', 'Yann', 'France'),
(5, 'Tavares', 'Leonel', 'France');

-- 3. Combattants
INSERT INTO combattant (Combattant_ID, Prénom_combattant, Nom_combattant, Date_de_naissance, Nationalité, Catégorie_de_poids, Statut_médical, Dernier_certificat_médical) VALUES
(1, 'Cyril', 'Gane', '1990-04-12', 'France', 'Poids Lourd', 'Apte', '2026-01-15'),
(2, 'Benoît', 'Saint-Denis', '1995-12-18', 'France', 'Poids Léger', 'Apte', '2026-02-10'),
(3, 'Nassourdine', 'Imavov', '1995-03-01', 'France', 'Poids Moyen', 'Apte', '2026-01-20'),
(4, 'Manon', 'Fiorot', '1990-02-17', 'France', 'Poids Mouche', 'Apte', '2026-03-05'),
(5, 'Jon', 'Jones', '1987-07-19', 'États-Unis', 'Poids Lourd', 'Apte', '2026-02-28'),
(6, 'Islam', 'Makhachev', '1991-10-27', 'Russie', 'Poids Léger', 'Apte', '2026-01-11'),
(7, 'Cédric', 'Doumbé', '1992-08-30', 'France', 'Poids Mi-Moyen', 'Apte', '2026-04-01'),
(8, 'Baysangur', 'Chamsoudinov', '2001-08-15', 'France', 'Poids Mi-Moyen', 'Apte', '2026-03-22'),
(9, 'Salahdine', 'Parnasse', '1997-12-04', 'France', 'Poids Plume', 'Apte', '2026-02-14'),
(10, 'Morgan', 'Charrière', '1995-10-26', 'France', 'Poids Plume', 'Apte', '2026-01-30');

-- 4. Licences
INSERT INTO licence (Numéro_Licence_Sportive, Date_délivrance, Date_expiration, ID_organisation, Combattant_ID) VALUES
('LIC-UFC-001', '2026-01-01', '2026-12-31', 1, 1),
('LIC-UFC-002', '2026-01-01', '2026-12-31', 1, 2),
('LIC-UFC-003', '2026-01-01', '2026-12-31', 1, 3),
('LIC-UFC-004', '2026-01-01', '2026-12-31', 1, 4),
('LIC-UFC-005', '2026-01-01', '2026-12-31', 1, 5),
('LIC-UFC-006', '2026-01-01', '2026-12-31', 1, 6),
('LIC-PFL-007', '2026-01-01', '2026-12-31', 2, 7),
('LIC-PFL-008', '2026-01-01', '2026-12-31', 2, 8),
('LIC-KSW-009', '2026-01-01', '2026-12-31', 3, 9),
('LIC-ARS-010', '2026-01-01', '2026-12-31', 4, 10);

-- 5. Performances
INSERT INTO performance (ID_performance, Nombre_de_victoires, Nombre_de_défaites, Nombre_de_matchs_nuls, Nombre_de_victoires_par_ko, Nombre_de_victoires_par_soumission, Combattant_ID) VALUES
(1, 12, 2, 0, 6, 3, 1),
(2, 13, 2, 0, 4, 8, 2),
(3, 15, 4, 0, 6, 4, 3),
(4, 12, 1, 0, 6, 0, 4),
(5, 27, 1, 0, 10, 7, 5),
(6, 26, 1, 0, 5, 12, 6),
(7, 5, 1, 0, 5, 0, 7),
(8, 9, 0, 0, 3, 3, 8),
(9, 19, 2, 0, 4, 7, 9),
(10, 19, 10, 1, 11, 3, 10);

-- 6. Medias
INSERT INTO media (ID_media, Nom_media, Type_media) VALUES
(1, 'RMC Sport', 'Télévision'),
(2, 'L Équipe', 'Presse / Digital'),
(3, 'UFC Fight Pass', 'Streaming'),
(4, 'DAZN France', 'Streaming'),
(5, 'La Sueur', 'Médias Web / YouTube');

-- 7. Combats
INSERT INTO combat (ID_combat, Résultat_combat, Durée_combat, Poids_autorisé, ID_arbitre) VALUES
(1, 'Victoire Gane KO R3', 740, 120.00, 1),
(2, 'Victoire BSD Soumission R2', 430, 70.30, 2),
(3, 'Victoire Imavov Décision Unanime', 1500, 83.90, 1),
(4, 'Victoire Fiorot Décision Unanime', 1500, 56.70, 3),
(5, 'Victoire Baki Décision Unanime', 1500, 77.10, 4),
(6, 'Victoire Parnasse KO R1', 145, 65.80, 5);

-- 8. Évènements
INSERT INTO évènement (ID_évènement, Nom_évènement, Date_évènement, Lieu_évènement, ID_media, ID_combat, ID_organisation) VALUES
(1, 'UFC Fight Night Paris 4', '2026-09-28', 'Accor Arena Paris', 1, 1, 1),
(2, 'PFL Europe Paris 2026', '2026-05-17', 'Adidas Arena Paris', 4, 5, 2),
(3, 'KSW 98 Paris', '2026-04-06', 'Dôme de Paris', 2, 6, 3),
(4, 'Ares 25', '2026-06-12', 'Palais des Sports Paris', 5, NULL, 4);

-- 9. Spectateurs
INSERT INTO spectateur (Téléphone_spectateur, Nom_spectateur, Prénom_spectateur, Email_spectateur) VALUES
('+33611223344', 'Dupont', 'Jean', 'jean.dupont@email.com'),
('+33622334455', 'Martin', 'Sophie', 'sophie.martin@email.com'),
('+33633445566', 'Benali', 'Youssef', 'youssef.benali@email.com'),
('+33644556677', 'Bernard', 'Lucas', 'lucas.bernard@email.com'),
('+33655667788', 'Petit', 'Emma', 'emma.petit@email.com'),
('+33666778899', 'Moreau', 'Thomas', 'thomas.moreau@email.com'),
('+33677889900', 'Lefebvre', 'Chloe', 'chloe.lefebvre@email.com'),
('+33688990011', 'Garcia', 'Antoine', 'antoine.garcia@email.com'),
('+33699001122', 'Roux', 'Camille', 'camille.roux@email.com'),
('+33600112233', 'Fournier', 'Hugo', 'hugo.fournier@email.com');

-- 10. Billets
INSERT INTO billet (ID_billet, Catégorie_billet, Prix_billet, ID_évènement, Téléphone_spectateur, ID_organisation) VALUES
(1, 'VIP Octogone', 450.00, 1, '+33611223344', 1),
(2, 'VIP Octogone', 450.00, 1, '+33622334455', 1),
(3, 'Catégorie 1', 180.00, 1, '+33633445566', 1),
(4, 'Catégorie 2', 95.00, 1, '+33644556677', 1),
(5, 'Catégorie 3', 55.00, 1, '+33655667788', 1),
(6, 'VIP Ring', 350.00, 2, '+33666778899', 2),
(7, 'Catégorie 1', 150.00, 2, '+33677889900', 2),
(8, 'Catégorie 2', 80.00, 2, '+33688990011', 2),
(9, 'VIP Octogone', 300.00, 3, '+33699001122', 3),
(10, 'Catégorie 1', 120.00, 3, '+33600112233', 3),
(11, 'Catégorie 3', 50.00, 1, NULL, 1),
(12, 'Catégorie 3', 50.00, 1, NULL, 1),
(13, 'Catégorie 2', 85.00, 4, NULL, 4),
(14, 'Catégorie 1', 140.00, 4, NULL, 4),
(15, 'VIP Octogone', 400.00, 4, NULL, 4);

-- 11. Sponsors
INSERT INTO sponsor (ID_Sponsor, Nom_sponsor, Type_de_sponsoring, Montant_sponsoring, Début_contrat_sponsor, Fin_contrat_sponsor) VALUES
(1, 'Venum', 'Equipementier Officiel', 250000.00, '2026-01-01', '2028-12-31'),
(2, 'Monster Energy', 'Boisson Officielle', 180000.00, '2026-01-01', '2027-12-31'),
(3, 'Crypto.com', 'Sponsor Titre', 500000.00, '2025-06-01', '2028-06-01'),
(4, 'Unibet', 'Paris Sportifs', 120000.00, '2026-01-01', '2026-12-31'),
(5, 'Stake', 'Partenaire Majeur', 300000.00, '2026-03-01', '2027-03-01');

-- 12. Participations (Combattant - Combat)
INSERT INTO participe (Combattant_ID, ID_combat) VALUES
(1, 1), (5, 1), -- Gane vs Jones
(2, 2), (6, 2), -- BSD vs Makhachev
(3, 3), (7, 4), -- Fiorot
(7, 5), (8, 5), -- Doumbe vs Baki
(9, 6);         -- Parnasse

-- 13. Licences Obligatoires pour Combats
INSERT INTO est_obligatoire (Numéro_Licence_Sportive, ID_combat) VALUES
('LIC-UFC-001', 1),
('LIC-UFC-005', 1),
('LIC-UFC-002', 2),
('LIC-UFC-006', 2),
('LIC-PFL-007', 5),
('LIC-PFL-008', 5);

-- 14. Financements (Évènement - Sponsor)
INSERT INTO finance (ID_évènement, ID_Sponsor) VALUES
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 4), (2, 5),
(3, 1), (3, 4),
(4, 2), (4, 5);
