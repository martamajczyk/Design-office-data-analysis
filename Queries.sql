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
INNER JOIN projekty_inwestorzy prin ON i.inwestor_id =prin.inwestor_id 
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

