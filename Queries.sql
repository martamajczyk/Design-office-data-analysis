-- Employees ordered by the largest number of completed projects:

SELECT CONCAT(p.pracownik_imie, ' ', p.pracownik_nazwisko) AS pracownik,
       COUNT(pp.projekt_pracownik_id) AS liczba_projektow
FROM pracownicy p
LEFT JOIN projekty_pracownicy pp ON p.pracownik_id = pp.pracownik_id
GROUP BY p.pracownik_imie, p.pracownik_nazwisko
ORDER BY liczba_projektow DESC;


-- Employees ordered by the highest revenue generated from projects:

SELECT CONCAT(p.pracownik_imie, ' ', p.pracownik_nazwisko) AS pracownik,
       COALESCE(SUM(pr.projekt_cena_umowa),0) AS obrot
FROM pracownicy p
LEFT JOIN projekty_pracownicy pp ON p.pracownik_id = pp.pracownik_id 
LEFT JOIN projekty pr ON pr.projekt_id = pp.projekt_id
GROUP BY p.pracownik_imie, p.pracownik_nazwisko
ORDER BY obrot DESC;


-- The most popular months to start the project, ordered by the number of projects:

SELECT 
CASE EXTRACT(MONTH FROM p.projekt_data_rozpoczecia)
        WHEN 1 THEN 'styczeń'
        WHEN 2 THEN 'luty'
        WHEN 3 THEN 'marzec'
        WHEN 4 THEN 'kwiecień'
        WHEN 5 THEN 'maj'
        WHEN 6 THEN 'czerwiec'
        WHEN 7 THEN 'lipiec'
        WHEN 8 THEN 'sierpień'
        WHEN 9 THEN 'wrzesień'
        WHEN 10 THEN 'październik'
        WHEN 11 THEN 'listopad'
        WHEN 12 THEN 'grudzień'
END AS nazwa_miesiaca,
COUNT(*) AS liczba_projektow
FROM projekty p
GROUP BY EXTRACT(MONTH FROM p.projekt_data_rozpoczecia)
ORDER BY liczba_projektow DESC;


-- The most popular months to finish the project, ordered by the number of projects:

SELECT 
CASE EXTRACT(MONTH FROM p.projekt_data_zakonczenia)
        WHEN 1 THEN 'styczeń'
        WHEN 2 THEN 'luty'
        WHEN 3 THEN 'marzec'
        WHEN 4 THEN 'kwiecień'
        WHEN 5 THEN 'maj'
        WHEN 6 THEN 'czerwiec'
        WHEN 7 THEN 'lipiec'
        WHEN 8 THEN 'sierpień'
        WHEN 9 THEN 'wrzesień'
        WHEN 10 THEN 'październik'
        WHEN 11 THEN 'listopad'
        WHEN 12 THEN 'grudzień'
END AS nazwa_miesiaca,
COUNT(*) AS liczba_projektow
FROM projekty p
GROUP BY EXTRACT(MONTH FROM p.projekt_data_zakonczenia)
ORDER BY liczba_projektow DESC;


-- Top 3 design styles in the office: 

SELECT s.stylistyka_nazwa AS styl, COUNT(s.stylistyka_id) AS ilosc_projektow
FROM stylistyka s 
LEFT JOIN projekty p ON p.stylistyka_id = s.stylistyka_id 
GROUP BY styl 
ORDER BY ilosc_projektow DESC 
LIMIT 3;


-- Top 2 selling packages by quantity (package name, category and quantity):

SELECT p.pakiet_nazwa AS pakiet, p.pakiet_kategoria AS kategoria, COUNT(pr.pakiet_id) AS ilosc_projektow
FROM pakiety p 
LEFT JOIN projekty pr ON p.pakiet_id = pr.pakiet_id 
GROUP BY p.pakiet_nazwa, p.pakiet_kategoria 
ORDER BY ilosc_projektow DESC
LIMIT 2;

-- Top 3 projects with the largest planned budget (investor's full name and city when project is located):

SELECT CONCAT(i.inwestor_imie, ' ', i.inwestor_nazwisko) AS inwestor, 
	   p.projekt_budzet_planowany AS budzet,
	   a.adres_miasto AS miasto
FROM inwestorzy i 
INNER JOIN projekty_inwestorzy prin ON i.inwestor_id = prin.inwestor_id 
INNER JOIN projekty p ON prin.projekt_id = p.projekt_id 
INNER JOIN adresy a ON p.adres_id = a.adres_id 
GROUP BY budzet, inwestor, miasto 
ORDER BY budzet DESC
LIMIT 3;

-- or another option:

WITH dane_o_projekcie AS 
	(
    	SELECT CONCAT(i.inwestor_imie, ' ', i.inwestor_nazwisko) AS inwestor, 
        	   p.projekt_budzet_planowany AS budzet,
               a.adres_miasto AS miasto
    	FROM inwestorzy i 
    	INNER JOIN projekty_inwestorzy prin ON i.inwestor_id = prin.inwestor_id 
    	INNER JOIN projekty p ON prin.projekt_id = p.projekt_id 
    	INNER JOIN adresy a ON p.adres_id = a.adres_id 
	)
SELECT inwestor, budzet, miasto
FROM dane_o_projekcie
GROUP BY inwestor, budzet, miasto
ORDER BY budzet DESC
LIMIT 3;

-- Investments in which the most projects were carried out, in descending order:

SELECT COUNT(p.inwestycja_id) AS ilosc_projektow, i.inwestycja_nazwa 
FROM projekty p
INNER JOIN inwestycje i ON p.inwestycja_id = i.inwestycja_id 
GROUP BY p.inwestycja_id, i.inwestycja_nazwa 
ORDER BY ilosc_projektow DESC;


-- The most popular ways to reach clients who bring the highest profits for the project in the descending order:

SELECT i.inwestor_sposob_dotarcia AS sposob_dotarcia,
       SUM(p.projekt_cena_umowa) AS najwiekszy_dochod
FROM inwestorzy i
INNER JOIN projekty_inwestorzy prin ON i.inwestor_id = prin.inwestor_id
INNER JOIN projekty p ON p.projekt_id = prin.projekt_id 
GROUP BY i.inwestor_sposob_dotarcia
ORDER BY najwiekszy_dochod DESC;

-- or another option:

WITH najbardziej_dochodowi_inwestorzy AS
	(		
 		SELECT SUM(p.projekt_cena_umowa) AS najwiekszy_dochod, i.inwestor_id
 		FROM inwestorzy i
 		INNER JOIN projekty_inwestorzy prin ON i.inwestor_id = prin.inwestor_id
 		INNER JOIN projekty p ON prin.projekt_id = p.projekt_id
 		GROUP BY i.inwestor_id
	),
	najpopularniejszy_sposob_dotarcia AS 
	(
		SELECT i.inwestor_id, i.inwestor_sposob_dotarcia, COUNT(*) AS liczba_inwestorow
		FROM inwestorzy i
		GROUP BY i.inwestor_id, i.inwestor_sposob_dotarcia
	)
SELECT npsd.inwestor_sposob_dotarcia AS sposob_dotarcia,
       SUM(ndi.najwiekszy_dochod) AS suma_dochodow
FROM najbardziej_dochodowi_inwestorzy ndi
INNER JOIN najpopularniejszy_sposob_dotarcia npsd ON ndi.inwestor_id = npsd.inwestor_id
GROUP BY npsd.inwestor_sposob_dotarcia
ORDER BY suma_dochodow DESC;

-- Average square footage of the apartment/house in private and investment projects (as two categories) and average price for the project in 2022:

SELECT pk.pakiet_kategoria AS kategoria,
       ROUND(AVG(p.projekt_metraz), 2) AS metraz, 
       ROUND(AVG(p.projekt_cena_umowa),2) AS cena
FROM projekty p 
INNER JOIN pakiety pk ON p.pakiet_id = pk.pakiet_id 
WHERE pk.pakiet_kategoria IN ('inwestycyjny', 'prywatny') AND EXTRACT(YEAR FROM p.projekt_data_umowa) = 2022
GROUP BY pk.pakiet_kategoria;

