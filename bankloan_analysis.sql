use bankloan;
SELECT 
    *
FROM
    financial_loan;

-- Total Number of Application 
-- count the distinct ids, as it is the primary key 

SELECT 
    COUNT(id) AS total_loan_application
FROM
    financial_loan;

-- Month-to-Date Applications
-- with respect to issue_date 
-- date when the particular loan has been issued to the customer 
-- Since we have data for just one year which is 2021 till December 
-- so we calculate MTD for the month of December 

SELECT 
    COUNT(id) AS MTD_Total_Loan_Applcations
FROM
    financial_loan
WHERE
    MONTH(issue_date) = 12;

ALTER TABLE financial_loan ADD COLUMN issue_date_new DATE;

UPDATE financial_loan 
SET 
    issue_date_new = STR_TO_DATE(issue_date, '%d-%m-%Y');

ALTER TABLE financial_loan DROP COLUMN issue_date;

SELECT 
    issue_date
FROM
    financial_loan;

ALTER TABLE financial_loan CHANGE COLUMN issue_date_new issue_date DATE;
-- Previous Month to Date Applications 

SELECT 
    COUNT(id) AS PMTD_Total_Loan_Applications
FROM
    financial_loan
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021;

-- (MTD - PMTD)/PMTD

SELECT 
    SUM(loan_amount) AS total_funded_amount
FROM
    financial_loan;

-- MTD Total Funded Amount
SELECT 
    SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM
    financial_loan
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021;

-- PMTD Total Funded Amount
SELECT 
    SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM
    financial_loan
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021;

-- Total Received Amount
-- total_payment has the data

SELECT 
    SUM(total_payment) AS Total_Amount_Received
FROM
    financial_loan;

-- MTD
SELECT 
    SUM(total_payment) AS MTD_Total_Amount_Received
FROM
    financial_loan
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021;

-- PMTD
SELECT 
    SUM(total_payment) AS PMTD_Total_Amount_Received
FROM
    financial_loan
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021;

-- Average Interest Rate 

SELECT 
    ROUND(AVG(int_rate) * 100, 2) AS Avg_Interest_Rate
FROM
    financial_loan;

-- MTD Average Interest Rate
SELECT 
    ROUND(AVG(int_rate) * 100, 2) AS MTD_Avg_Interest_Rate
FROM
    financial_loan
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021;

-- PMTD Avg Interest Rate
SELECT 
    ROUND(AVG(int_rate) * 100, 2) AS PMTD_Avg_Interest_Rate
FROM
    financial_loan
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021;

-- Average DTI- Debt to Income Ratio

SELECT 
    ROUND(AVG(dti) * 100, 2) AS Avg_DTI
FROM
    financial_loan;

-- MTD Average DTI 
SELECT 
    ROUND(AVG(dti) * 100, 2) AS MTD_Avg_DTI
FROM
    financial_loan
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021;

-- PMTD Average DTI 
SELECT 
    ROUND(AVG(dti) * 100, 2) AS PMTD_Avg_DTI
FROM
    financial_loan
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021;

-- Good Loans Issued
-- where the loan status is fully paid or current which means they are currently repaying the loan regularly on time 

SELECT 
    (COUNT(CASE
        WHEN
            loan_status = 'Fully Paid'
                OR loan_status = 'Current'
        THEN
            id
    END) * 100.0) / COUNT(id) AS Good_Loan_Percentage
FROM
    financial_loan;

-- Good Loan Total Applications 

SELECT 
    COUNT(id) AS Good_Loan_Applications
FROM
    financial_loan
WHERE
    loan_status = 'Fully Paid'
        OR loan_status = 'Current';

-- Good Loan Total Funded Amount

SELECT 
    SUM(loan_amount) AS Good_Loan_Funded_Amount
FROM
    financial_loan
WHERE
    loan_status IN ('Fully Paid' , 'Current');

-- Good Loan Total Received Amount 

SELECT 
    SUM(total_payment) AS Good_Loan_Received_Amount
FROM
    financial_loan
WHERE
    loan_status IN ('Fully Paid' , 'Current');

-- Bad Loans Issued 
-- where the loan status is charged off which means they are not repaying the loan regularly on time 

SELECT 
    ROUND((COUNT(CASE
                WHEN loan_status = 'Charged Off' THEN id
            END) * 100.0) / COUNT(id),
            2) AS Bad_Loan_Percentage
FROM
    financial_loan;

-- Bad Loan Total Applications 

SELECT 
    COUNT(id) AS Bad_Loan_Applications
FROM
    financial_loan
WHERE
    loan_status = 'Charged Off';

-- Bad Loan Total Funded Amount

SELECT 
    SUM(loan_amount) AS Bad_Loan_Funded_Amount
FROM
    financial_loan
WHERE
    loan_status = 'Charged Off';

-- Bad Loan Total Received Amount 

SELECT 
    SUM(total_payment) AS Bad_Loan_Received_Amount
FROM
    financial_loan
WHERE
    loan_status = 'Charged Off';

-- Grid view of distinct loan status 

SELECT 
    loan_status,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Amount_Funded,
    SUM(total_payment) AS Total_Amount_Received,
    ROUND(AVG(int_rate) * 100, 2) AS Average_Interest_Rate,
    ROUND(AVG(dti) * 100, 2) AS Average_DTI
FROM
    financial_loan
GROUP BY 1
ORDER BY 2 DESC;

-- Overview View of bank loan data spread through month

SELECT 
    MONTH(issue_date) AS Month_Number,
    MONTHNAME(issue_date) AS `Month`,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM
    financial_loan
GROUP BY 1 , 2
ORDER BY 1;

-- Regional Analysis by State
SELECT 
    address_state AS State,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM
    financial_loan
GROUP BY 1
ORDER BY 1;

-- Loan data spread w.r.t the terms

SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY 1
ORDER BY 1;

-- Loan Data wrt employee length, which is the time they have served 

SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY 1
ORDER BY 1;

-- Pupose of loan

SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY 1
ORDER BY 1;

-- Home Ownership 

SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY 1
ORDER BY 1;







