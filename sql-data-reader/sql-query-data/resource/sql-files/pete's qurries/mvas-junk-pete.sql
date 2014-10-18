mvas - junk - pete 

select * from ACCOUNTSPROVIDEDPROPERTIES APP
join PLANXSMAPPING PX on APP.ACCOUNTSPROVIDEDID = PX.ACCOUNTSPROVIDEDID
where element = 'ADJUSTMENT_REPLACE' and PX.XSTYPE_ID = 4;

select * from MASTERPROPERTIES where element = 'ADJUSTMENT_REPLACE';
select * from payroll_schedule_dates;
select * from CUSTOMER;
select * from ACCOUNTENROLLMENT;
select * from payroll_hist;
select * from PAYROLL_VENDOR_SPLIT;
select * from PAYROLL_PER_PAY_COMP;
select * from PAYROLL_INPUT; where STATUS = 'PROCESSED';
select * from INPUT_FILE;
select * from batch_process_detail where batch_id = 'b26132b372f440e082fa5765ac16b293' and row_number = 3 ;

select * from CLIENTXSMAPPING where CLIENT_XSID = '003872';
select * from client where id = 841;

select CX.CLIENT_XSID, cp.client_id, cp. element, CP.value from CLIENTPROPERTIES CP
join clientxsmapping cx on cx.client_id = cp.client_id
where element = 'ALLOW_ABO';
select * from MASTERSOURCES where type = 'Employer';
select * from MASTERSOURCE_FUNCTION where function = 'EMPLOYER';
select CP.* from clientproperties CP 
--join CLIENTXSMAPPING CX on CP.CLIENT_ID = CX.CLIENT_ID
where CP.element like '%END%' 
--and CP.employer_ID = 1
--and cx.client_xsid = '054303'
;

select * from payroll_schedule_dates;
select CAB.* from CUSTOMER_ACCEL_BENEFIT CAB
join LOCATION_CUSTOMER lc on cab.LOCATION_CUSTOMER_ID = LC.LOCATION_CUSTOMER_ID
join CUSTOMER C on LC.CUSTOMER_PK = C.PK
where c.username = '580826364'
;

select * from SUBPLAN_XS_MAPPING;
select * from PAYROLL_PRODUCT_SPLIT;
select * from ACCOUNT_VENDOR_PRODUCT;
select * from client_VENDOR_PRODUCT;
select * from PAYROLL_VENDOR_SPLIT PVS
join PAYROLL_PRODUCT_SPLIT PS on PS.PAYROLL_INPUT_ID = PVS.PAYROLL_INPUT_ID
join ACCOUNT_VENDOR_PRODUCT AVP on AVP.ACCOUNT_VENDOR_PRODUCT_ID = PS.ACCOUNT_VENDOR_PRODUCT_ID
join CLIENT_VENDOR_PRODUCT CVP on CVP.CLIENT_VENDOR_PRODUCT_ID = AVP.CLIENT_VENDOR_PRODUCT_ID
join SUBPLAN_XS_MAPPING SXM on SXM.VENDOR_PRODUCT_ID = CVP.VENDOR_PRODUCT_ID
where PVS.PAYROLL_VENDOR_SPLIT_ID = '94cba57712b84a91aecd54701fa808e0';
;

join PLAN_CLIENT_VENDOR PCV on PCV.PLAN_CLIENT_VENDOR_ID = PVS.PLAN_CLIENT_VENDOR_ID
join CLIENT_VENDOR CV on PCV.CLIENT_VENDOR_ID = CV.CLIENT_VENDOR_ID
join VENDOR_PRODUCT VP on CV.VENDORID = VP.VENDORID
join SUBPLAN_XS_MAPPING SXM on SXM.VENDOR_PRODUCT_ID = VP.VENDOR_PRODUCT_ID
where PVS.PAYROLL_VENDOR_SPLIT_ID = '94cba57712b84a91aecd54701fa808e0';
select * from PLAN_CLIENT_VENDOR;
select * from CLIENT_VENDOR;
select * from VENDOR_PRODUCT;

select * from CUSTOMER_ACCEL_BENEFIT CAB
join LOCATION_CUSTOMER lc on cab.LOCATION_CUSTOMER_ID = LC.LOCATION_CUSTOMER_ID
join CUSTOMER C on LC.CUSTOMER_PK = C.PK
join location L on LC.LOCATION_ID = L.id
join EMPLOYER E on L.EMPLOYER_ID = E.id
join CLIENTXSMAPPING CX on CX.CLIENT_ID = E.CLIENT_ID
where CX.CLIENT_XSID = '062026'
and c.username in ('388717536','388717537','388717534','388717535','388717532','388717533')
;

