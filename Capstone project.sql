select *
from donation_data;

Q1
SELECT SUM(donation) as TotalAmount
From donation_data;

Q2
SELECT Sum(donation), gender
FROM donation_data
GROUP BY gender;

Q3
SELECT gender, SUM(donation) as TOTAL_DONATION,
COUNT(donation) as G_Donation
FROM donation_data
GROUP BY gender;

Q4
SELECT donation_frequency, SUM(donation) as total_donation
FROM donation_data as dd
INNER JOIN donor_data as dr_d
ON dd.id = dr_d.id
GROUP BY donation_frequency;

Q5
SELECT job_field, SUM(donation) as total_donation,
COUNT (donation) as num_donations
FROM donation_data as dd
INNER JOIN donor_data as dr_d
ON dd.id = dr_d.id
GROUP BY job_field;

Q6
SELECT SUM(donation),
COUNT (donation) as Donations_above_$200
FROM donation_data
WHERE donation>200;

Q7
SELECT SUM(donation),
COUNT (donation) as Donations_above_$200
FROM donation_data
WHERE donation<200;

Q8
SELECT SUM(donation) as Donation, state
FROM donation_data
GROUP BY state
ORDER BY SUM(donation) DESC
LIMIT 10;

Q9
SELECT SUM(donation) as Donation, state
FROM donation_data
GROUP BY state
ORDER BY SUM(donation) ASC
LIMIT 10;

Q10
SELECT donation_frequency, car
FROM donor_data as dr_d
GROUP BY donation_frequency, car
ORDER BY donation_frequency DESC
LIMIT 10;

SELECT first_name, last_name, car, donation
FROM donation_data as dd
INNER JOIN donor_data as dr_d
ON dd.id = dr_d.id
GROUP BY first_name, last_name, donation, car
ORDER BY donation DESC
LIMIT 10;




