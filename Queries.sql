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


-- 3 most popular styles in the office: 

SELECT s.stylistyka_nazwa AS styl, COUNT(s.stylistyka_id) AS ilosc_projektow
FROM stylistyka s 
LEFT JOIN projekty p ON p.stylistyka_id = s.stylistyka_id 
GROUP BY styl 
ORDER BY ilosc_projektow DESC 
LIMIT 3;


-- Two best selling packages by quantity (package name, category and quantity):

SELECT p.pakiet_nazwa AS pakiet, p.pakiet_kategoria AS kategoria, COUNT(pr.pakiet_id) AS ilosc_projektow
FROM pakiety p 
LEFT JOIN projekty pr ON p.pakiet_id = pr.pakiet_id 
GROUP BY p.pakiet_nazwa, p.pakiet_kategoria 
ORDER BY ilosc_projektow DESC
LIMIT 2;




