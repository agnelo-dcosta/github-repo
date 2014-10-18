 SELECT px.PLAN_XSID AS PLAN_NUMBER,  c.lastname , c.firstname ,c.middlename ,  c.username, ea.attribute_value AS IPIN,     
 ACTUAL_CONTRIBUTION AS ACTUAL_CONTRIBUTION,EXPECTED_CONTRI AS EXPECTED_CONTRIBUTION,  lx.location_xsid,ms.sourcename,lc.location_customer_id,al.id as accountlocation_id, 
 L.ID AS LOCATION_ID,E.ID AS EMPLOYER_ID,E.CLIENT_ID AS CLIENT_ID 
 FROM 
 (SELECT lc.location_customer_id as lc_location_customer_id,PI.ACCOUNTSOURCEID as PI_ACCOUNTSOURCEID, al.id as al_accountlocation_id,SUM(PI.EXPECTED_CONTRI) as EXPECTED_CONTRI ,SUM(PI.INCOMING_CONTRIBUTION) as ACTUAL_CONTRIBUTION FROM
 PAYROLL_INPUT PI
 join accountsource asr on asr.accountsourceid = PI.ACCOUNTSOURCEID   
 join accountenrollment ae on ae.accountenrollmentid =PI.ACCOUNTENROLLMENTID  
 join accountlocations al ON al.id = ae.accountlocation_id        
 join customer c ON c.customerid = ae.customerid        
 join location_customer lc ON lc.CUSTOMER_PK = c.PK AND lc.location_id = al.location_id      
 JOIN MASTERSOURCES MS ON MS.MASTERSOURCESID = ASR.MASTERSOURCESID      
 WHERE
 PI.DISBURSEMENT_BATCH_ID = 'b61eb64cf5294da8baae4ad3268379c0' and pi.input_type = 'COMBINED' and pi.remittance_type in ('CONTRIBUTION', 'ESCROW') and ms.sourcename is not null 
 GROUP BY lc.location_customer_id,al.id,PI.ACCOUNTSOURCEID) 
  
 join accountsource asr on asr.accountsourceid = PI_ACCOUNTSOURCEID   
 join accountsprovided ap ON asr.accountsprovidedid = ap.accountsprovidedid 
 join mastersources ms on ms.mastersourcesid = asr.mastersourcesid      
 join mastersource_function mf on mf.mastersourcename = ms.sourcename and mf.function in ('OSDA','NON-OSDA') 
 join accountlocations al ON al.id = al_accountlocation_id        
 join location_customer lc ON lc.location_customer_id = lc_location_customer_id      
 join customer c ON c.pk = lc.customer_pk        
 join location l on l.id = lc.location_id  
 join employer e on e.id = l.employer_id  
 join LOCATIONXSMAPPING lx ON lc.location_id = lx.location_id          
 join PLANXSMAPPING px ON asr.accountsprovidedid = px.accountsprovidedid    and px.xstype_id = 4  
  left outer join EXTENDED_ATTRIBUTE ea ON TO_CHAR(lc.LOCATION_CUSTOMER_ID) = ea.PARENT_ID        
 AND UPPER(ea.parent_table) = 'LOCATION_CUSTOMER'         
 AND UPPER(EA.ATTRIBUTE_TYPE) = 'CLIENT_EMPLOYEE_ID'  
 WHERE  
 ACTUAL_CONTRIBUTION is not null and EXPECTED_CONTRI is not null and ACTUAL_CONTRIBUTION  != EXPECTED_CONTRI 
