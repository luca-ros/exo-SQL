--1 Nom des lieux qui finissent par 'um'.
SELECT nom_lieu FROM lieu
WHERE nom_lieu LIKE '%um'

--2 Nombre de personnages par lieu
SELECT nom_lieu, COUNT(p.id_lieu) AS nbGaulois
FROM lieu l
INNER JOIN personnage p ON p.id_lieu = l.id_lieu
GROUP BY nom_lieu
ORDER BY nbGaulois DESC

--3 Nom des personnages + spécialité + adresse et lieu d'habitation,
SELECT nom_personnage, nom_specialite, adresse_personnage, nom_lieu
FROM personnage p
INNER JOIN specialite s ON p.id_specialite = s.id_specialite
INNER JOIN lieu l ON l.id_lieu = p.id_lieu
ORDER BY nom_lieu, nom_personnage

--4 Nom des spécialités avec nombre de personnages par spécialité
SELECT nom_specialite, COUNT(v.id_personnage) AS nb_Gaulois
FROM personnage v, specialite s, lieu l
WHERE v.id_specialite = s.id_specialite
ORDER BY nb_Gaulois DESC

--5 Nom, date et lieu des batailles, classées de la plus récente à la plus ancienne
SELECT nom_bataille, nom_lieu, DATE_FORMAT(date_bataille, "%d/%m/%Y")
FROM bataille b, lieu l
WHERE l.id_lieu = b.id_lieu
ORDER BY date_bataille DESC

--6 Nom des potions + coût de réalisation de la potion (trié par coût décroissant).
SELECT nom_potion, SUM(i.cout_ingredient * c.qte) AS cout
FROM ingredient i, composer c, potion p 
WHERE c.id_potion = p.id_potion 
AND c.id_ingredient = i.id_ingredient
GROUP BY nom_potion
ORDER BY cout DESC

--7 Nom des ingrédients + coût + ??quantité de chaque ingrédient qui composent la potion 'Santé'.??
SELECT i.id_ingredient, i.nom_ingredient, i.cout_ingredient, c.qte, SUM(i.cout_ingredient*c.qte) AS total
FROM ingredient i
INNER JOIN composer c ON c.id_ingredient = i.id_ingredient
INNER JOIN potion p ON c.id_potion = p.id_potion
WHERE p.nom_potion = 'Santé'
GROUP BY i.id_ingredient, i.nom_ingredient, i.cout_ingredient, c.qte

--8 Nom du ou des personnages qui ont pris le plus de casques dans la bataille 'Bataille du village gaulois'.
SELECT nom_personnage, SUM(pc.qte) AS nbCasques
FROM personnage p, prendre_casque pc, bataille b 
WHERE p.id_personnage = pc.id_personnage
AND pc.id_bataille = b.id_bataille
AND b.nom_bataille = "Bataille du village gaulois"
GROUP BY p.nom_personnage
ORDER BY nbCasques DESC 

--9 Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur au plus petit).
SELECT nom_personnage, dose_boire
FROM personnage p, boire b
WHERE p.id_personnage = b.id_personnage
ORDER BY b.id_personnage DESC 

--10 Nom de la bataille où le nombre de casques pris a été le plus important.
SELECT nom_bataille, SUM(qte) AS nbCasqueMax
FROM bataille b 
INNER JOIN prendre_casque pc ON b.id_bataille = pc.id_bataille
GROUP BY nom_bataille
HAVING nbCasqueMax >= ALL(
    SELECT SUM(qte) 
    FROM bataille b
    INNER JOIN prendre_casque pc ON b.id_bataille = pc.id_bataille
    GROUP BY nom_bataille)

--11 Combien existe-t-il de casques de chaque type et quel est leur coût total ? (classés par nombre décroissant)
SELECT nom_type_casque, COUNT(id_casque) AS nbCasque, SUM(cout_casque) AS coutCasque
FROM casque c
INNER JOIN type_casque tc ON tc.id_type_casque = c.id_type_casque
GROUP BY nom_type_casque
ORDER BY coutCasque DESC

--12 Nom des potions dont un des ingrédients est le poisson frais.
SELECT nom_potion
FROM potion p 
INNER JOIN composer c ON c.id_potion = p.id_potion
INNER JOIN ingredient i ON i.id_ingredient = c.id_ingredient
WHERE nom_ingredient = 'Poisson frais'
GROUP BY nom_potion

--13 Lieu qui a le plus d'habitants en dehors du Village gaulois
  SELECT nom_lieu, COUNT(id_personnage) AS nbPerso
    FROM lieu l
    INNER JOIN personnage p ON p.id_lieu = l.id_lieu
    WHERE nom_lieu != 'Village gaulois'
    GROUP BY nom_lieu
    HAVING nbPerso >= ALL(
        SELECT COUNT(id_personnage)
        FROM lieu l
        INNER JOIN personnage p ON p.id_lieu = l.id_lieu
        WHERE nom_lieu != 'Village gaulois'
        GROUP BY nom_lieu)

--14 Nom des personnages qui n'ont jamais bu aucune potion.
    SELECT nom_personnage
    FROM personnage p
    LEFT JOIN boire b ON p.id_personnage = b.id_personnage
    WHERE b.id_personnage IS NULL
    GROUP BY nom_personnage

--15 Nom du / des personnages qui n'ont pas le droit de boire de la potion 'Magique'.
 SELECT nom_personnage
    FROM personnage p
    WHERE id_personnage NOT IN (
        SELECT id_personnage
        FROM autoriser_boire ab
        INNER JOIN potion po ON ab.id_potion = po.id_potion
        WHERE nom_potion = 'Magique')
    ORDER BY nom_personnage

--En écrivant toujours des requêtes SQL, modifiez la base de données comme suit :
--A Ajoutez le personnage suivant : Champdeblix, agriculteur résidant à la ferme Hantassion de Rotomagus.
INSERT INTO personnage VALUES ("Champdeblix", "agriculteur", "à la ferme Hantassion de Rotomagus")
--B Autorisez Bonemine à boire de la potion magique, elle est jalouse d'Iélosubmarine...

--C Supprimez les casques grecs qui n'ont jamais été pris lors d'une bataille.

--D Modifiez l'adresse de Zérozérosix : il a été mis en prison à Condate.

--E La potion 'Soupe' ne doit plus contenir de persil.

--F Obélix s'est trompé : ce sont 42 casques Weisenau, et non Ostrogoths, qu'il a pris lors de la bataille 'Attaque de la banque postale'. Corrigez son erreur
