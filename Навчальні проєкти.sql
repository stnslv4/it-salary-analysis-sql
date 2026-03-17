-- ==========================================================
-- PROJECT: Data Science Salary Analysis
-- Author: Stanislav Holovenko
-- ==========================================================
SELECT *
FROM salaries



/* Запит №1. Вплив віддаленої роботи на дохід*/
/* КЕЙС: Аналіз впливу віддаленої роботи на рівень заробітної плати.
МЕТА: З'ясувати, чи існує "фінансова надбавка" за роботу в офісі, 
чи віддалені працівники отримують конкурентну оплату.
КОНТЕКСТ: remote_ration 0 (офіс), 50 (гібрид), 100 (повна віддаленка).
*/
SELECT remote_ration, 
       ROUND(AVG(salary_in_isd), 0) AS avg_salary
FROM salaries
GROUP BY 1;



/* Запит №2. Порівняння зарплат за рівнем досвіду */ 
/* КЕЙС: Аналіз залежності рівня доходу від професійного стажу.
МЕТА: Оцінити темпи зростання заробітної плати при переході між грейдами.
КОНТЕКСТ: 
 - EN: Entry-level (Junior)
 - MI: Mid-level (Middle)
 - SE: Senior-level
 - EX: Executive-level (Director/VP)
*/
SELECT exp_level, 
       MIN(salary_in_isd) AS min_salary,
       MAX(salary_in_isd) AS max_salary,
       ROUND(AVG(salary_in_isd), 0) AS avg_salary
FROM salaries
GROUP BY 1
ORDER BY 4 ASC;



/* Запит №3. Порівняння зарплат у різних країнах (comp_location) тільки для Data Analysts*/ 
/* КЕЙС: Регіональний аналіз доходів для ролі Data Analyst.
МЕТА: Визначити найбільш вигідні країни для працевлаштування саме аналітиком.
ОСОБЛИВОСТІ: 
 - Використовується фільтрація за конкретною посадою (job_tytle).
 - Додано обмеження за кількістю записів (analyst_count > 1) для підвищення статистичної значущості.
*/
SELECT comp_location, 
       COUNT(*) AS analyst_count,
       MIN(salary_in_isd) AS min_salary,
       MAX(salary_in_isd) AS max_salary,
       ROUND(AVG(salary_in_isd), 0) AS avg_salary_usd
FROM salaries
WHERE job_tytle = 'Data Analyst'
GROUP BY 1
HAVING COUNT(*) > 1 -- країни, де є хоча б 2 записи
ORDER BY 5 DESC;



/* Запит №4. Де платять більше: у стартапах чи корпораціях */
/* КЕЙС: Вплив масштабу компанії на рівень оплати праці.
МЕТА: З'ясувати, чи пропонують великі корпорації вищі зарплати порівняно з малим та середнім бізнесом.
КОНТЕКСТ: 
 - S: Small (малі компанії/стартапи)
 - M: Medium (середній бізнес)
 - L: Large (великі корпорації)
*/
SELECT comp_size, 
       COUNT(*) AS number_of_jobs,
       ROUND(AVG(salary_in_isd), 0) AS avg_salary_usd
FROM salaries
GROUP BY 1
ORDER BY 3 DESC;



/* Запит №5. Топ-5 найбільш високооплачуваних ролей */ 
/* КЕЙС: Рейтинг найбільш прибуткових посад у сфері даних.
МЕТА: Визначити ТОП-5 професій з найвищою середньою зарплатою.
ОСОБЛИВОСТІ: 
 - HAVING COUNT(*) > 5: відсіюємо унікальні або рідкісні позиції для отримання 
   статистично достовірного результату (репрезентативність вибірки).
 - LIMIT 5: фокусуємо увагу лише на лідерах рейтингу.
*/
SELECT job_tytle, 
       ROUND(AVG(salary_in_isd), 0) AS avg_salary_usd
FROM salaries
GROUP BY job_tytle
HAVING COUNT(*) > 5 -- беремо тільки популярні ролі для точності
ORDER BY 2 DESC
LIMIT 5;


/* Запит №6. Знайдіть внутрішні та міжнародні продажі для кожного фільму
 КЕЙС: Аналіз деталізації клієнтських замовлень.
МЕТА: Об'єднати дані про замовлення з інформацією про конкретні товари в них.
ОСОБЛИВОСТІ: 
 - Використання INNER JOIN для поєднання таблиць orders та order_details.
 - Робота з аліасами для оптимізації читабельності коду.
*/

SELECT title, 
domestic_sales, 
international_sales 
FROM movies
  JOIN boxoffice
    ON movies.id = boxoffice.movie_id;


/* Запит №7. Перелічіть усі фільми за їхніми рейтингами у спадаючому порядку
 КЕЙС: Рейтинг популярності кінофільмів.
МЕТА: Об'єднати описові дані про фільми з їхніми оцінками для виявлення найбільш успішних проектів.
ІНСТРУМЕНТИ: INNER JOIN для поєднання таблиць за первинним ключем (id).
*/

SELECT title, rating
FROM movies
JOIN boxoffice ON movies.id = boxoffice.movie_id
ORDER BY rating DESC;

/* Запит №8. Перерахуйте всі будівлі та різні ролі працівників у кожній будівлі (включно з порожніми будівлями)
 КЕЙС: Технічний огляд кінопроєктів.
МЕТА: Отримати дані про тривалість фільмів, поєднавши їхні назви з таблицею специфікацій.
ОСОБЛИВОСТІ: 
 - Об'єднання таблиць movies та boxoffice за ідентифікатором фільму.
 - Демонстрація вміння працювати зі структурними зв'язками бази даних.
*/

SELECT DISTINCT building_name, role 
FROM buildings 
  LEFT JOIN employees
    ON building_name = building;