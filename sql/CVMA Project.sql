# 1 Find All Volunteers with Specific Skills in a Location
SELECT v.name, v.location, v.email_id, s.skill_name
FROM volunteer v
JOIN volunteer_skills vs ON v.volunteer_id = vs.volunteer_id
JOIN skills s ON vs.skill_id = s.skill_id
WHERE s.skill_name = 'Event Coordination' 
  AND v.location = 'Toronto';

# 2 List All Volunteers with Their Complete Skill Sets
SELECT v.name, v.location, v.tenure, 
       GROUP_CONCAT(s.skill_name, ', ') AS skills
FROM volunteer v
LEFT JOIN volunteer_skills vs ON v.volunteer_id = vs.volunteer_id
LEFT JOIN skills s ON vs.skill_id = s.skill_id
GROUP BY v.volunteer_id, v.name, v.location, v.tenure;  

# 3 Find Volunteers Available for Long-Term Commitments
SELECT v.name, v.location, v.tenure, v.email_id, v.bio
FROM volunteer v
WHERE v.tenure IN ('6 months', '8 months', '1 year')
  AND v.email_verified = 1
ORDER BY v.tenure;

# 4 Show Volunteers with Multiple Skills (Versatile Volunteers)
SELECT v.name, v.location, COUNT(vs.skill_id) AS skill_count,
       GROUP_CONCAT(s.skill_name, ', ') AS skills
FROM volunteer v
JOIN volunteer_skills vs ON v.volunteer_id = vs.volunteer_id
JOIN skills s ON vs.skill_id = s.skill_id
GROUP BY v.volunteer_id, v.name, v.location
HAVING COUNT(vs.skill_id) >= 3
ORDER BY skill_count DESC;

# 5 Find Volunteers Who Haven't Applied to Any Event Yet
SELECT v.volunteer_id, v.name, v.email_id, v.location, v.created_date
FROM volunteer v
LEFT JOIN application a ON v.volunteer_id = a.volunteer_id
WHERE a.application_id IS NULL
ORDER BY v.created_date DESC;

# 6 List Volunteers in Kingston with Customer Service Skills
SELECT v.name, v.email_id, v.phone_number, s.skill_name
FROM volunteer v
JOIN volunteer_skills vs ON v.volunteer_id = vs.volunteer_id
JOIN skills s ON vs.skill_id = s.skill_id
WHERE v.location = 'Kingston' 
  AND s.skill_name = 'Customer Service';
  
# 7 Find Verified Volunteers by Registration Date
SELECT v.name, v.email_id, v.location, v.created_date, v.email_verified
FROM volunteer v
WHERE v.email_verified = 1
ORDER BY v.created_date DESC
LIMIT 10;

# 8 Find All Open Events in a Specific Location
SELECT e.opportunity_name, e.description, e.location, e.tenure, e.startdate,
       o.name AS organization_name, o.causetype
FROM event e
JOIN organization o ON e.organization_id = o.organization_id
WHERE e.location = 'Toronto' 
  AND e.status = 'open'
ORDER BY e.startdate;

# 9 Show Events with Required Skills
SELECT e.opportunity_name, e.location, e.tenure, 
       o.name AS organization_name,
       GROUP_CONCAT(s.skill_name, ', ') AS required_skills
FROM event e
JOIN organization o ON e.organization_id = o.organization_id
JOIN event_skills es ON e.event_id = es.event_id
JOIN skills s ON es.skill_id = s.skill_id
WHERE e.status = 'open'
GROUP BY e.event_id, e.opportunity_name, e.location, e.tenure, o.name;

# 10 Match Sara's Skills to Available Events in Toronto
SELECT DISTINCT e.opportunity_name, e.description, e.location, e.startdate,
       o.name AS organization_name, s.skill_name
FROM volunteer v
JOIN volunteer_skills vs ON v.volunteer_id = vs.volunteer_id
JOIN event_skills es ON vs.skill_id = es.skill_id
JOIN event e ON es.event_id = e.event_id
JOIN organization o ON e.organization_id = o.organization_id
JOIN skills s ON vs.skill_id = s.skill_id
WHERE v.volunteer_id = 3  -- Sara Ali
  AND e.status = 'open'
  AND e.location = 'Toronto';
  
# 11  Find Short-Term Opportunities (1 Day to 1 Week)
SELECT e.opportunity_name, e.location, e.tenure, e.startdate,
       o.name AS organization_name, o.causetype
FROM event e
JOIN organization o ON e.organization_id = o.organization_id
WHERE e.tenure IN ('1 day', '1 week', '1 evening')
  AND e.status = 'open'
ORDER BY e.startdate;

# 12 List All Events by a Specific Cause Type
SELECT e.opportunity_name, e.description, e.location, e.startdate,
       o.name AS organization_name, o.causetype
FROM event e
JOIN organization o ON e.organization_id = o.organization_id
WHERE o.causetype IN ('Youth', 'Seniors')
  AND e.status = 'open'
ORDER BY o.causetype, e.startdate;

# 13 Find Events with No Applications Yet
SELECT e.event_id, e.opportunity_name, e.location, e.createDate,
       o.name AS organization_name, o.causetype
FROM event e
JOIN organization o ON e.organization_id = o.organization_id
LEFT JOIN application a ON e.event_id = a.event_id
WHERE a.application_id IS NULL
  AND e.status = 'open'
ORDER BY e.createDate DESC;

# 14 Show All Applications for a Specific Volunteer
SELECT v.name AS volunteer_name, e.opportunity_name, 
       o.name AS organization_name, a.application_date, 
       a.status, a.desired_tenure
FROM application a
JOIN volunteer v ON a.volunteer_id = v.volunteer_id
JOIN event e ON a.event_id = e.event_id
JOIN organization o ON e.organization_id = o.organization_id
WHERE v.volunteer_id = 6  -- David Kim
ORDER BY a.application_date DESC;

# 15 Show All Applications for a Specific Event
SELECT a.application_id, v.name AS volunteer_name, v.email_id, 
       v.phone_number, v.location, a.application_date, a.status,
       GROUP_CONCAT(s.skill_name, ', ') AS volunteer_skills
FROM application a
JOIN volunteer v ON a.volunteer_id = v.volunteer_id
JOIN event e ON a.event_id = e.event_id
LEFT JOIN volunteer_skills vs ON v.volunteer_id = vs.volunteer_id
LEFT JOIN skills s ON vs.skill_id = s.skill_id
WHERE e.event_id = 7
GROUP BY a.application_id, v.name, v.email_id, v.phone_number, v.location, a.application_date, a.status
ORDER BY a.application_date;

# 16  Find All Accepted Applications
SELECT v.name AS volunteer_name, v.location, e.opportunity_name, 
       o.name AS organization_name, a.application_date, a.status
FROM application a
JOIN volunteer v ON a.volunteer_id = v.volunteer_id
JOIN event e ON a.event_id = e.event_id
JOIN organization o ON e.organization_id = o.organization_id
WHERE a.status = 'accepted'
ORDER BY a.application_date DESC;

# 17 Find Pending Applications Needing Review
SELECT a.application_id, v.name AS volunteer_name, v.email_id,
       e.opportunity_name, o.name AS organization_name, 
       a.application_date, a.status
FROM application a
JOIN volunteer v ON a.volunteer_id = v.volunteer_id
JOIN event e ON a.event_id = e.event_id
JOIN organization o ON e.organization_id = o.organization_id
WHERE a.status = 'pending'
ORDER BY a.application_date;

# 18  Show Volunteers Who Applied to Multiple Events
SELECT v.name, v.location, v.email_id, 
       COUNT(a.application_id) AS total_applications,
       SUM(CASE WHEN a.status = 'accepted' THEN 1 ELSE 0 END) AS accepted_count
FROM volunteer v
JOIN application a ON v.volunteer_id = a.volunteer_id
GROUP BY v.volunteer_id, v.name, v.location, v.email_id
HAVING COUNT(a.application_id) >= 2
ORDER BY total_applications DESC;

# 19  Show Rejected Applications with Reasons (Feedback Loop)
SELECT v.name AS volunteer_name, e.opportunity_name, 
       o.name AS organization_name, o.causetype,
       a.application_date, a.status
FROM application a
JOIN volunteer v ON a.volunteer_id = v.volunteer_id
JOIN event e ON a.event_id = e.event_id
JOIN organization o ON e.organization_id = o.organization_id
WHERE a.status = 'rejected'
ORDER BY a.application_date DESC;

# 20 Show All Events Posted by a Specific Organization
SELECT o.name AS organization_name, e.opportunity_name, 
       e.location, e.startdate, e.status, e.createDate,
       COUNT(a.application_id) AS application_count
FROM organization o
JOIN event e ON o.organization_id = e.organization_id
LEFT JOIN application a ON e.event_id = a.event_id
WHERE o.organization_id = 5  -- Seniors Connection
GROUP BY o.name, e.event_id, e.opportunity_name, e.location, e.startdate, e.status, e.createDate
ORDER BY e.createDate DESC;

# 21 Compare Premium vs Free Organizations' Application Rates
SELECT o.subscription_type, 
       COUNT(DISTINCT o.organization_id) AS org_count,
       COUNT(e.event_id) AS total_events,
       COUNT(a.application_id) AS total_applications,
       ROUND(CAST(COUNT(a.application_id) AS FLOAT) / COUNT(e.event_id), 2) AS avg_applications_per_event
FROM organization o
LEFT JOIN event e ON o.organization_id = e.organization_id
LEFT JOIN application a ON e.event_id = a.event_id
GROUP BY o.subscription_type;

# 22 Find Premium Organizations with Most Applications
SELECT o.name AS organization_name, o.subscription_type, o.causetype,
       COUNT(DISTINCT e.event_id) AS events_posted,
       COUNT(a.application_id) AS total_applications
FROM organization o
JOIN event e ON o.organization_id = e.organization_id
LEFT JOIN application a ON e.event_id = a.event_id
WHERE o.subscription_type = 'Premium'
GROUP BY o.organization_id, o.name, o.subscription_type, o.causetype
ORDER BY total_applications DESC;

# 23 List Organizations by Verification Status
SELECT o.name, o.contact_person, o.email_id, o.location, 
       o.causetype, o.verification_status, o.created_date
FROM organization o
WHERE o.verification_status = 'pending'
ORDER BY o.created_date;

# 24 Show Most In-Demand Skills
SELECT s.skill_name, s.category, 
       COUNT(es.event_id) AS events_requiring_skill,
       COUNT(DISTINCT e.organization_id) AS organizations_requesting
FROM skills s
JOIN event_skills es ON s.skill_id = es.skill_id
JOIN event e ON es.event_id = e.event_id
WHERE e.status = 'open'
GROUP BY s.skill_id, s.skill_name, s.category
ORDER BY events_requiring_skill DESC;

# 25 Find Skills with Most Volunteers
SELECT s.skill_name, s.category, 
       COUNT(vs.volunteer_id) AS volunteer_count
FROM skills s
JOIN volunteer_skills vs ON s.skill_id = vs.skill_id
GROUP BY s.skill_id, s.skill_name, s.category
ORDER BY volunteer_count DESC;

# 26 Match Volunteers to Events by Skill Category
SELECT DISTINCT v.name AS volunteer_name, v.location,
       e.opportunity_name, o.name AS organization_name,
       s.skill_name, s.category
FROM volunteer v
JOIN volunteer_skills vs ON v.volunteer_id = vs.volunteer_id
JOIN skills s ON vs.skill_id = s.skill_id
JOIN event_skills es ON s.skill_id = es.skill_id
JOIN event e ON es.event_id = e.event_id
JOIN organization o ON e.organization_id = o.organization_id
WHERE s.category = 'Health'
  AND e.status = 'open'
ORDER BY v.name, e.opportunity_name;

# 27 Find Events Requiring Multiple Specific Skills
SELECT e.opportunity_name, o.name AS organization_name, 
       e.location, e.tenure,
       COUNT(es.skill_id) AS skills_required,
       GROUP_CONCAT(s.skill_name, ', ') AS required_skills
FROM event e
JOIN organization o ON e.organization_id = o.organization_id
JOIN event_skills es ON e.event_id = es.event_id
JOIN skills s ON es.skill_id = s.skill_id
WHERE e.status = 'open'
GROUP BY e.event_id, e.opportunity_name, o.name, e.location, e.tenure
HAVING COUNT(es.skill_id) >= 2
ORDER BY skills_required DESC;

# 28 Show Volunteers with Rare Skills
SELECT v.name, v.location, v.email_id, s.skill_name,
       (SELECT COUNT(*) FROM volunteer_skills vs2 WHERE vs2.skill_id = s.skill_id) AS skill_rarity
FROM volunteer v
JOIN volunteer_skills vs ON v.volunteer_id = vs.volunteer_id
JOIN skills s ON vs.skill_id = s.skill_id
WHERE (SELECT COUNT(*) FROM volunteer_skills vs2 WHERE vs2.skill_id = s.skill_id) <= 2
ORDER BY skill_rarity, v.name;

# 29 Show Complete Skill Matching Overview
SELECT s.skill_name, s.category,
       COUNT(DISTINCT vs.volunteer_id) AS volunteers_with_skill,
       COUNT(DISTINCT es.event_id) AS events_requiring_skill,
       CASE 
         WHEN COUNT(DISTINCT vs.volunteer_id) = 0 THEN 'No Supply'
         WHEN COUNT(DISTINCT es.event_id) = 0 THEN 'No Demand'
         WHEN COUNT(DISTINCT vs.volunteer_id) > COUNT(DISTINCT es.event_id) THEN 'Oversupplied'
         WHEN COUNT(DISTINCT vs.volunteer_id) < COUNT(DISTINCT es.event_id) THEN 'Undersupplied'
         ELSE 'Balanced'
       END AS supply_demand_status
FROM skills s
LEFT JOIN volunteer_skills vs ON s.skill_id = vs.skill_id
LEFT JOIN event_skills es ON s.skill_id = es.skill_id
GROUP BY s.skill_id, s.skill_name, s.category
ORDER BY s.skill_name;

# 30 Find Volunteers and Their Application Success Rate
SELECT v.name AS volunteer_name, v.location,
       COUNT(a.application_id) AS total_applications,
       SUM(CASE WHEN a.status = 'accepted' THEN 1 ELSE 0 END) AS accepted,
       SUM(CASE WHEN a.status = 'rejected' THEN 1 ELSE 0 END) AS rejected,
       SUM(CASE WHEN a.status = 'pending' THEN 1 ELSE 0 END) AS pending,
       ROUND(CAST(SUM(CASE WHEN a.status = 'accepted' THEN 1 ELSE 0 END) AS FLOAT) * 100.0 / COUNT(a.application_id), 1) AS success_rate_percent
FROM volunteer v
JOIN application a ON v.volunteer_id = a.volunteer_id
GROUP BY v.volunteer_id, v.name, v.location
HAVING COUNT(a.application_id) > 0
ORDER BY success_rate_percent DESC;

# 31 Show Events by Location with Application Statistics
SELECT e.location, 
       COUNT(DISTINCT e.event_id) AS total_events,
       COUNT(DISTINCT a.volunteer_id) AS unique_applicants,
       COUNT(a.application_id) AS total_applications,
       ROUND(CAST(COUNT(a.application_id) AS FLOAT) / COUNT(DISTINCT e.event_id), 1) AS avg_applications_per_event
FROM event e
LEFT JOIN application a ON e.event_id = a.event_id
WHERE e.status = 'open'
GROUP BY e.location
ORDER BY total_applications DESC;

# 32 Find Organizations with No Accepted Applications Yet
SELECT o.name AS organization_name, o.causetype, o.subscription_type,
       COUNT(DISTINCT e.event_id) AS events_posted,
       COUNT(a.application_id) AS total_applications,
       SUM(CASE WHEN a.status = 'accepted' THEN 1 ELSE 0 END) AS accepted_applications
FROM organization o
JOIN event e ON o.organization_id = e.organization_id
LEFT JOIN application a ON e.event_id = a.event_id
GROUP BY o.organization_id, o.name, o.causetype, o.subscription_type
HAVING COUNT(a.application_id) > 0 
   AND SUM(CASE WHEN a.status = 'accepted' THEN 1 ELSE 0 END) = 0
ORDER BY total_applications DESC;

# 33 Show Organizations and Events with Contact Details for Premium Features
SELECT o.name AS organization_name, o.subscription_type,
       e.opportunity_name, e.location,
       v.name AS applicant_name, v.email_id AS applicant_email, 
       v.phone_number AS applicant_phone,
       a.status AS application_status, a.application_date
FROM organization o
JOIN event e ON o.organization_id = e.organization_id
JOIN application a ON e.event_id = a.event_id
JOIN volunteer v ON a.volunteer_id = v.volunteer_id
WHERE o.subscription_type = 'Premium'
  AND a.status IN ('accepted', 'pending')
ORDER BY o.name, e.opportunity_name, a.application_date;

