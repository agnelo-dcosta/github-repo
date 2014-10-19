--feedback tbljobqueue
select * From tbljobqueue tj
join  tblworkflowheaderproperty twh on twh.workflowid = tj.workflowid
where twh.propertyvalue like '%<Feedback_file_name>%' order by createdate desc;



--Contribution suspension report sql -> Make sure that client, employer, location IDs and BATCH_ID is proper before running the sql
select max(C.LASTNAME) as LASTNAME, max(C.FIRSTNAME) as FIRSTNAME, max(CR.LAST_CONTRIBUTION_DATE) as LAST_CONTRIBUTION_DATE,  
                max(LC.TERMINATION_DATE) as TERMINATION_DATE,  cr.limit_test_name, cr.limit,
                CR.PLAN_NUMBERS, EA.ATTRIBUTE_VALUE, CR.CLIENT_ID, CX.CLIENT_XSID, CR.EMPLOYER_ID, EX.EMPLOYER_XSID, CR.LOCATION_ID, LX.LOCATION_XSID
        from COMPLIANCE_RESULT CR  
            join CUSTOMER C ON C.CUSTOMERID = CR.CUSTOMER_ID  
            join LOCATION_CUSTOMER LC on LC.CUSTOMER_PK = C.PK AND LC.LOCATION_ID = CR.LOCATION_ID  
            join EXTENDED_ATTRIBUTE EA on EA.PARENT_TABLE = 'LOCATION_CUSTOMER' and EA.PARENT_ID = LC.LOCATION_CUSTOMER_ID and EA.ATTRIBUTE_TYPE = 'CLIENT_EMPLOYEE_ID'  
            join CLIENTXSMAPPING CX on CX.CLIENT_ID = CR.CLIENT_ID  
            join EMPLOYERXSMAPPING EX on EX.EMPLOYER_ID = CR.EMPLOYER_ID  
            join LOCATIONXSMAPPING LX on LX.LOCATION_ID = CR.LOCATION_ID 
            join  tblworkflowheaderproperty twh on twh.propertyvalue like '%<Feedback_file_name>%'
            join tblworkflowheaderproperty twh_batchid on twh.workflowid = twh_batchid.workflowid and twh_batchid.element = 'BATCH_ID' 
    where  CR.REPORT_TYPE = 'CONTRI_SUSPENSION_RPT' and CR.BATCH_ID = twh_batchid.propertyvalue
      and c.username = '<SSN>'
      group by cr.limit_test_name, cr.limit, CR.PLAN_NUMBERS, EA.ATTRIBUTE_VALUE, CR.CLIENT_ID, CX.CLIENT_XSID, CR.EMPLOYER_ID, EX.EMPLOYER_XSID, CR.LOCATION_ID, LX.LOCATION_XSID
      order by max(C.LASTNAME), EA.ATTRIBUTE_VALUE, EX.EMPLOYER_XSID, LX.LOCATION_XSID ;

--Adjustment report contents 
select C.LASTNAME, C.FIRSTNAME, EA.ATTRIBUTE_VALUE, CR.PLAN_NUMBERS, CR.FIN_YEAR, CR.LIMIT, CR.YTD_CONTRI_ER, CR.YTD_CONTRI_EE, CR.ORIG_CONTRI_ER, CR.ORIG_CONTRI_EE,  
                CR.ADJ_CONTRI_ER, CR.EXCEEDED_AMOUNT, CR.ADJ_CONTRI_EE, CR.CLIENT_ID, CR.EMPLOYER_ID, CR.LOCATION_ID,CX.CLIENT_XSID, EX.EMPLOYER_XSID, LX.LOCATION_XSID 
        from COMPLIANCE_RESULT CR  
            join CUSTOMER C ON C.CUSTOMERID = CR.CUSTOMER_ID  
            join LOCATION_CUSTOMER LC on LC.CUSTOMER_PK = C.PK AND LC.LOCATION_ID = CR.LOCATION_ID  
            join EXTENDED_ATTRIBUTE EA on EA.PARENT_TABLE = 'LOCATION_CUSTOMER' and EA.PARENT_ID = LC.LOCATION_CUSTOMER_ID and EA.ATTRIBUTE_TYPE = 'CLIENT_EMPLOYEE_ID'  
            join CLIENTXSMAPPING CX on CX.CLIENT_ID = CR.CLIENT_ID  
            join EMPLOYERXSMAPPING EX on EX.EMPLOYER_ID = CR.EMPLOYER_ID  
            join LOCATIONXSMAPPING LX on LX.LOCATION_ID = CR.LOCATION_ID
            join  tblworkflowheaderproperty twh on twh.propertyvalue like '%<Feedback_file_name>%'
            join tblworkflowheaderproperty twh_batchid on twh.workflowid = twh_batchid.workflowid and twh_batchid.element = 'BATCH_ID' 
      where  CR.REPORT_TYPE = 'CONTRI_ADJUSTMENT_RPT' and CR.BATCH_ID = twh_batchid.propertyvalue
      and c.username = '<SSN>'
      order by C.LASTNAME, EX.EMPLOYER_XSID, LX.LOCATION_XSID;
      
      
     

-- 415 forecast report
select C.CUSTOMERID, C.LASTNAME, C.FIRSTNAME, EA.ATTRIBUTE_VALUE, CR.PLAN_NUMBERS, CR.YTD_CONTRI_ER, CR.YTD_CONTRI_EE, CR.FORECASTED_ANNUAL_ER_CONTRI,  
    CR.FORECASTED_ANNUAL_EE_CONTRI, CR.LIMIT, CR.CONTRI_VARIANCE_415, LFC.LIMIT_FORECASTED_CONTRI_ID, LFC.YEAR_FORECAST_CONTRI_ER, LFC.YEAR_FORECAST_CONTRI_EE,  
    CR.FIN_YEAR, CR.CLIENT_ID, CR.EMPLOYER_ID, CR.LOCATION_ID, CX.CLIENT_XSID, EX.EMPLOYER_XSID, LX.LOCATION_XSID   from COMPLIANCE_RESULT CR  
   join CUSTOMER C ON C.CUSTOMERID = CR.CUSTOMER_ID  
   join LOCATION_CUSTOMER LC on LC.CUSTOMER_PK = C.PK AND LC.LOCATION_ID = CR.LOCATION_ID  
   join EXTENDED_ATTRIBUTE EA on EA.PARENT_TABLE = 'LOCATION_CUSTOMER' and EA.PARENT_ID = LC.LOCATION_CUSTOMER_ID and EA.ATTRIBUTE_TYPE = 'CLIENT_EMPLOYEE_ID'  
   join CLIENTXSMAPPING CX on CX.CLIENT_ID = CR.CLIENT_ID  
   join EMPLOYERXSMAPPING EX on EX.EMPLOYER_ID = CR.EMPLOYER_ID  
   join LOCATIONXSMAPPING LX on LX.LOCATION_ID = CR.LOCATION_ID 
   left outer join LIMIT_FORECASTED_CONTRI LFC ON LFC.CLIENT_ID = CR.CLIENT_ID AND LFC.CUSTOMER_ID = CR.CUSTOMER_ID AND LFC.FIN_YEAR = CR.FIN_YEAR   
   join  tblworkflowheaderproperty twh on twh.propertyvalue like '%<Feedback_file_name>%'
   join tblworkflowheaderproperty twh_batchid on twh.workflowid = twh_batchid.workflowid and twh_batchid.element = 'BATCH_ID' 
   where  CR.REPORT_TYPE = 'FORECAST_RPT_415' and CR.BATCH_ID = twh_batchid.propertyvalue and CR.EXCLUDE is null and c.username = '<SSN>'
        order by max(C.LASTNAME), max(C.FIRSTNAME), EA.ATTRIBUTE_VALUE, EX.EMPLOYER_XSID, LX.LOCATION_XSID;


--Feedback batch_report
select * from batch_report br 
join  tblworkflowheaderproperty twh on twh.propertyvalue like '%<Feedback_file_name>%'
join tblworkflowheaderproperty twh_batchid on twh.workflowid = twh_batchid.workflowid and twh_batchid.element = 'BATCH_ID' 
where batch_id =  twh_batchid.propertyvalue ;

--batch_process_detail
select * from batch_process_detail bpd 
join customer c on c.customerid = bpd.customerid
where c.username = '<SSN>';
