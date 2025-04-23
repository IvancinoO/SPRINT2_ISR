# --------------------- NIVELL 1

# Exercici 2
# Utilitzant JOIN realitzaràs les següents consultes:

# Llistat dels països que estan fent compres.

SELECT DISTINCT country
FROM company;

# Des de quants països es realitzen les compres.

SELECT COUNT(DISTINCT country) as Cdt_Paises
FROM company;

# Identifica la companyia amb la mitjana més gran de vendes.

SELECT company_name
FROM company
JOIN ( 
		SELECT AVG(amount), company_id
		FROM transaction
		GROUP BY company_id
		ORDER BY 1 DESC
		LIMIT 1) as subq
ON company.id = subq.company_id;


# Exercici 3
# Utilitzant només subconsultes (sense utilitzar JOIN):

# Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT *
FROM transaction
WHERE company_id IN (
					SELECT id
					FROM company
					WHERE country = "Germany");
                    
# Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.

SELECT company_name
FROM company
WHERE id IN (
			SELECT company_id
			FROM transaction 
			WHERE declined = 0 AND amount > (
											SELECT AVG(amount)
											FROM transaction));

# Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

SELECT company_name
FROM company
WHERE id NOT IN (
				SELECT company_id
				FROM transaction);


# --------------------- NIVELL 2

# Exercici 1
# Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. Mostra la data de cada transacció juntament amb el total de les vendes

SELECT DATE(timestamp), sum(amount) AS Total_Ventas
FROM transaction
WHERE declined = 0
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

# Exercici 2
# Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.

SELECT country, AVG(amount) as Mitja_Vendes
FROM company as c
JOIN transaction as t ON t.company_id = c.id
GROUP BY 1
ORDER BY 2 DESC;

# Exercici 3
# En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute". 
# Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.

# Mostra el llistat aplicant JOIN i subconsultes.

SELECT *
FROM transaction
JOIN (
		SELECT id
		FROM company
		WHERE country = (
						SELECT country
						FROM company
						WHERE company_name = 'Non institute')) as subq
ON transaction.company_id = subq.id;

# Mostra el llistat aplicant solament subconsultes.

SELECT *
FROM transaction
WHERE company_id IN (
					SELECT id
					FROM transactions.company
					WHERE country = (
									SELECT country
									FROM transactions.company
									WHERE company_name = 'Non institute'));
          
          
# --------------------- NIVELL 3

# Exercici 1
# Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 100 i 200 euros 
# i en alguna d'aquestes dates: 29 d'abril del 2021, 20 de juliol del 2021 i 13 de març del 2022. Ordena els resultats de major a menor quantitat.

SELECT company_name, phone, country, subq.timestamp, subq.amount
FROM company
JOIN (
		SELECT company_id, amount, timestamp
		FROM transaction
		WHERE (amount between 100 and 200) AND (DATE(timestamp) = '2021-04-29' OR DATE(timestamp) = '2021-07-20' OR DATE(timestamp) = '2022-03-13')) AS subq
ON company.id = subq.company_id
ORDER BY subq.amount DESC;


# Exercici 2
# Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
# per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, 
# però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.

SELECT company_name, subq.Mas_d4_Trans
FROM company
JOIN (
	 SELECT company_id, COUNT(id),
	 CASE
	 WHEN COUNT(id) >= 4 THEN 'SI'
     ELSE 'NO'
     END AS Mas_d4_Trans
     FROM transaction
     WHERE declined = 0
     GROUP BY company_id) AS subq
     ON company.id = subq.company_id;




