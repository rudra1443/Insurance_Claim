
-- Question_01:- Which policy types generate the higest number of claims?

SELECT
    p.Policy_Type,
    COUNT(c.Claim_ID) AS claim_count
FROM Claims c
JOIN Policies p ON c.Policy_ID = p.Policy_ID
GROUP BY p.Policy_Type
ORDER BY claim_count DESC;

-- Question_02:-Which policy types generate the highest total claim amount?

SELECT 
    p.Policy_Type,
    SUM(c.Claim_Amount) AS total_claim_amount
    FROM claims c 
JOIN Policies p ON c.Policy_ID = p.Policy_ID 
GROUP BY p.Policy_Type 
ORDER BY total_claim_amount ;

-- Question_03:- Which customer segment have the highest claim frequency?

WITH customer_segments AS (
    SELECT
        Customer_ID,
        CASE
            WHEN Annual_Income < 500000 THEN 'Low (<500K)'
            WHEN Annual_Income <= 1000000 THEN 'Middle (500K-1M)'
            ELSE 'High (>1M)'
        END AS income_segment
    FROM Customers
)
SELECT
    cs.income_segment,
    COUNT(c.Claim_ID) AS total_claims,
    COUNT(DISTINCT c.Customer_ID) AS customers_with_claims,
    ROUND(
        COUNT(c.Claim_ID) * 1.0 / COUNT(DISTINCT c.Customer_ID),
        2
    ) AS claims_per_customer
FROM Claims c
JOIN customer_segments cs ON c.Customer_ID = cs.Customer_ID
GROUP BY cs.income_segment
ORDER BY claims_per_customer DESC;

-- Question_04:- What is the average claim amount by policy type?

SELECT 
    p.Policy_Type,
    ROUND(AVG(c.Claim_Amount), 2) AS average_claim_amount
    FROM claims c 
    JOIN policies p ON c.Policy_ID = p.Policy_ID 
    GROUP BY p.Policy_Type 
    ORDER BY average_claim_amount ;

-- Question_05:- What percentage of claims are approved, Rejected, Pending, and Under Review?

SELECT
    Claim_Status,
    COUNT(*) AS claim_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS claim_percentage
FROM Claims
GROUP BY Claim_Status
ORDER BY claim_percentage DESC;

-- Question_06. What is the average claimn processing time by claim type
SELECT
    Claim_Type,
    ROUND(AVG(Processing_Days), 2) AS avg_processing_days
FROM Claims
GROUP BY Claim_Type
ORDER BY avg_processing_days DESC;

-- Question_07.Which claim types have the highest approval rate?

SELECT
    Claim_Type,
    COUNT(*) AS total_claims,
    SUM(CASE WHEN Claim_Status = 'Approved' THEN 1 ELSE 0 END) AS approved_claims,
    ROUND(
        100.0 * SUM(CASE WHEN Claim_Status = 'Approved' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS approval_rate
FROM Claims
GROUP BY Claim_Type
ORDER BY approval_rate DESC;

-- Question_08.Which cities have the highest claim volume and total claim value?

SELECT
    cu.City,
    COUNT(c.Claim_ID) AS claim_volume,
    SUM(c.Claim_Amount) AS total_claim_value
FROM Claims c
JOIN Customers cu ON c.Customer_ID = cu.Customer_ID
GROUP BY cu.City
ORDER BY claim_volume DESC, total_claim_value DESC;

-- Question_09. What is the gap between the amount claimed and the amount approed by the insurance?

SELECT
    SUM(Claim_Amount) AS total_claimed_amount,
    SUM(Approved_Amount) AS total_approved_amount,
    SUM(Claim_Amount - Approved_Amount) AS approval_gap,
    ROUND(
        100.0 * SUM(Claim_Amount - Approved_Amount)
        / SUM(Claim_Amount),
        2
    ) AS gap_percentage
FROM Claims;

-- Question_10 Which claims or claim segments show the highest fraud risk and financial exposure?

SELECT
    Claim_Type,
    COUNT(*) AS claim_count,
    ROUND(100.0 * AVG(Fraud_Flag), 2) AS fraud_rate,
    SUM(CASE WHEN Fraud_Flag = 1 THEN Claim_Amount ELSE 0 END) AS flagged_claim_exposure,
    SUM(Claim_Amount) AS total_claim_exposure
FROM Claims
GROUP BY Claim_Type
ORDER BY fraud_rate DESC, flagged_claim_exposure DESC;














