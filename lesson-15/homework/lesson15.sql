SELECT id, name, salary
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);
SELECT id, product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);
SELECT id, name
FROM employees
WHERE department_id = (SELECT id FROM departments WHERE department_name = 'Sales');
SELECT c.customer_id, c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
SELECT e.id, e.name, e.salary, e.department_id
FROM employees e
WHERE e.department_id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
    LIMIT 1
);
SELECT g.student_id, s.name, g.course_id, g.grade
FROM grades g
JOIN students s ON g.student_id = s.student_id
WHERE g.grade = (
    SELECT MAX(grade)
    FROM grades
    WHERE course_id = g.course_id
    GROUP BY course_id
);
SELECT e.id, e.name, e.salary, e.department_id
FROM employees e
JOIN (
    SELECT department_id, MAX(salary) AS max_salary
    FROM employees
    GROUP BY department_id
) dept_max ON e.department_id = dept_max.department_id
WHERE e.salary > (SELECT AVG(salary) FROM employees)
  AND e.salary < dept_max.max_salary;
