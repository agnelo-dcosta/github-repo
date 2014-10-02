update TBLJOBPROCESSOR set DESCRIPTION = 'EIS-L-PSELBY.envisagesystems.local';
--update TBLJOBPROCESSOR set DESCRIPTION = 'TIAACRSPRINT02.envisagesystems.local';

update MASTERPROPERTIES set value = 'tiaadevws.envisagesystems.local' where element = 'FTP_HOST_NAME';
--update masterproperties set Value = 'TIAACRSPRINT02.envisagesystems.local' where element = 'FTP_HOST_NAME';
update masterproperties set Value = 'root' where element = 'FTP_USER_NAME';
update masterproperties set Value = 'ligzimm09' where element = 'FTP_USER_PASSWORD';
update masterproperties set Value = '22' where element = 'FTP_PORT_NUMBER';
update masterproperties set value = 'SFTP' where element = 'FTP_SERVER_TYPE'; 
--the next three updates set the path for your local system ie C:\home\tester1\local\inbound
update masterproperties set Value = '/home/tester1/local/inbound' where element = 'FTP_LOCAL_INBOUND_DIRECTORY';
update masterproperties set Value = '/home/tester1/local/outbound' where element = 'FTP_LOCAL_OUTBOUND_DIRECTORY';
update masterproperties set value = '/home/tester1/system/outbound' where element = 'FTP_SYSTEM_OUTBOUND';
--the next 
update masterproperties set Value = '/home/selbyp/stac/remote/inbound' where element = 'FTP_REMOTE_INBOUND_DIRECTORY';
update masterproperties set Value = '/home/selbyp/stac/remote/outbound' where element = 'FTP_REMOTE_OUTBOUND_DIRECTORY';


--schedule clean up
DELETE FROM QRTZ_SIMPLE_TRIGGERS;
DELETE FROM qrtz_blob_triggers;
DELETE FROM QRTZ_TRIGGERS;
DELETE FROM QRTZ_JOB_DETAILS;
DELETE FROM SCHEDULE_HISTORY;
DELETE FROM SCHEDULE_GROUP_CYCLE_DATE;
DELETE FROM SCHEDULE_GROUP_CYCLE;
DELETE FROM SCHEDULE_GROUP_MEMBER;
DELETE FROM SCHEDULE_GROUP;
UPDATE PAYROLL_INPUT SET PAYROLL_SCHEDULE_ID = NULL WHERE PAYROLL_INPUT_ID IN (select payroll_input_id from payroll_input where payroll_schedule_id is not null);
DELETE FROM PAYROLL_SCHEDULE_DATES;
DELETE FROM PAYROLL_SCHEDULE;
DELETE FROM SCHEDULE_INSTANCE;

--------------------------------------------------------------------------------
--Customer
select * from CUSTOMER
where 1=1
--and CUSTOMERID = '932a82c6a3c0477f99c46e4b8d98d7c7'
--and USERNAME = '735828895'
--and pk = 61949
;

select * from ADDRESS where ADDRESSID = '108749';
select * from location_customer where LOCATION_CUSTOMER_ID = '67348';

--------------------------------------------------------------------------------
--Payroll Input
select c.username, pi.payroll_date, pi.* 
from payroll_product_split pv 
join payroll_input pi on pi.payroll_input_id = pv.payroll_input_id 
join accountenrollment ae on ae.accountenrollmentid = pi.accountenrollmentid 
join CUSTOMER C on C.CUSTOMERID = AE.CUSTOMERID 
--join accountsource acs on acs.accountsourceid = pi.accountsourceid 
--join MASTERSOURCES M on M.MASTERSOURCESID = ACS.MASTERSOURCESID 
--join accountlocations al on al.id = ae.accountlocation_id 
--join planxsmapping px on px.accountsprovidedid = al.accountsprovidedid and px.xstype_id = 4 
where 1=1
--and C.USERNAME = '004104321'
--and pi.payroll_date >= to_date('02-DEC-13','dd-mon-yy')
--and m.sourcename = 'E'
--and px.plan_xsid = ? and al.location_id = ? 
--group by pi.payroll_date 
order by PI.PAYROLL_DATE;
--------------------------------------------------------------------------------
--Location Customer
select LC.PER_PAY_HRS, LC.PER_PAY_COMP, LC.BONUS, LC.* from LOCATION_CUSTOMER LC join CUSTOMER C on LC.CUSTOMER_PK = C.PK
where c.username = '247400559'
;
--------------------------------------------------------------------------------
--Payroll History
select ph.* from PAYROLL_HIST ph 
join location_customer lc on lc.location_customer_id = ph.location_customer_id 
join CUSTOMER C on C.PK = LC.CUSTOMER_PK 
where  C.USERNAME = '123' 
;
--------------------------------------------------------------------------------
--Payroll Per Pay Comp
select c.username, pppc.* from payroll_per_pay_comp pppc 
join payroll_hist ph on pppc.payroll_hist_id = ph.payroll_hist_id
join location_customer lc on ph.location_customer_id = lc.location_customer_id
join customer c on lc.customer_pk = c.pk
--join accountenrollment ae on c.customerid = ae.customerid
--join accountlocations al on al.id = ae.accountlocation_id
--join planxsmapping px on px.accountsprovidedid = al.accountsprovidedid and px.xstype_id = 4 
where 1=1 
and c.username like '123'
--and px.plan_xsid = '151576' and al.location_id = 562 
order by PPPC.MODIFY_DATE desc;, PPPC.PAYROLL_DATE;
--------------------------------------------------------------------------------
--Location Name
select * from LOCATIONXSMAPPING LX join location L on LX.LOCATION_ID = L.id where LOCATION_XSID = 'P644';
--------------------------------------------------------------------------------
--Contribs by Payroll
select C.USERNAME, PI.PAYROLL_DATE, M.SOURCENAME, PX.PLAN_XSID, PV.CONTRIBUTION as TOTAL_CONTRIBUTION
from PAYROLL_vendor_SPLIT PV
join payroll_input pi on pi.payroll_input_id = pv.payroll_input_id
join accountenrollment ae on ae.accountenrollmentid = pi.accountenrollmentid
join customer c on c.customerid = ae.customerid
join accountsource acs on acs.accountsourceid = pi.accountsourceid
join mastersources m on m.mastersourcesid = acs.mastersourcesid
join PLANXSMAPPING PX on PX.ACCOUNTSPROVIDEDID = AE.ACCOUNTSPROVIDEDID and PX.XSTYPE_ID = 4
where 1=1
--and C.USERNAME like '400073002'
--and pi.PAYROLL_DATE >'31-DEC-2011' 
--and m.sourcename = ?
--and px.plan_xsid = ? and al.location_id = ?
--group by c.username, M.SOURCENAME, PX.PLAN_XSID;
order by C.USERNAME, PI.PAYROLL_DATE;
--------------------------------------------------------------------------------

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
where c.username = '738157088'
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


--sum of contributions
select username, sum(contribution) from 
( select C.CUSTOMERID, USERNAME, PI.PAYROLL_DATE,PX.PLAN_XSID,MS.SOURCENAME,PI.CONTRIBUTION,PI.INPUT_NAME,PI.INPUT_TYPE 
from CUSTOMER C,ACCOUNTENROLLMENT AE, PAYROLL_INPUT PI, MASTERSOURCES MS,ACCOUNTSOURCE ASRC,PLANXSMAPPING PX 
where c.customerid=ae.customerid and pi.accountenrollmentid = ae.accountenrollmentid and asrc.accountsourceid = pi.accountsourceid  
and MS.MASTERSOURCESID = ASRC.MASTERSOURCESID  and PX.ACCOUNTSPROVIDEDID=AE.ACCOUNTSPROVIDEDID and PX.XSTYPE_ID=4 
and c.username in ('400073002') 
and MS.SOURCENAME='E' 
and PAYROLL_DATE >'31-DEC-2010' 
--and PLAN_XSID in ('151562','151579')
)
group by username;

--ytd contribution
SELECT e.client_id,  px.plan_xsid,  c.customerid,  c.username,  pyc.*
from PARTICIPANT_YTD_CONTRI PYC
join ACCOUNTLOCATIONS AL on AL.id = PYC.ACCOUNTLOCATION_ID
join PLANXSMAPPING PX on PX.ACCOUNTSPROVIDEDID = AL.ACCOUNTSPROVIDEDID and PX.XSTYPE_ID = 4
JOIN accountsprovided ap ON ap.accountsprovidedid = al.accountsprovidedid
JOIN customer c ON c.customerid = pyc.customerid
join ACCOUNTSOURCE ASRC on ASRC.ACCOUNTSOURCEID = PYC.ACCOUNTSOURCEID
JOIN mastersources ms ON ms.mastersourcesid = asrc.mastersourcesid
JOIN location l ON l.id = al.location_id
join EMPLOYER E on E.id = L.EMPLOYER_ID
WHERE fin_year>2011
and SOURCENAME='E'
--and PLAN_XSID in ('151562','151579')
and USERNAME in ('400073002')
ORDER BY pyc.customerid DESC;

select * from tblworkflowheaderproperties
 
Example of the Data Repair was this:
update participant_ytd_contri set contribution_ytd = contribution_ytd - 2141.61
where PARTICIPANT_YTD_CONTRI_ID ='35baf4978b82425681860bb9ac5e2319'
and fin_year = 2014

select * from CLIENTXSMAPPING where CLIENT_XSID = '055378';
select * from CLIENT where id = 441;
select * from PAYROLL_SCHEDULE_DATES where PAYROLL_DATE = '01-OCT-14' and PAYROLL_SCHEDULE_ID = 'acf372589b5d4fb4a870de9c705625e0';
select * from SCHEDULE_INSTANCE where FILE_NAME_TEMPLATE like '%CR_054303_148974_148974%';
select * from CUSTOMER where CUSTOMERID = '9302d09f6fbd41edbbb774c61faad026';
select * from ACCOUNTENROLLMENT where CUSTOMERID ='9302d09f6fbd41edbbb774c61faad026';
select * from payroll_input; where ACCOUNTENROLLMENTID in ('e7b76bb6fdea4149a1de558397dab0ca', '6548c30a316c4a4488c975d8b22a5d12');
Insert into PAYROLL_INPUT (PAYROLL_INPUT_ID, ACCOUNTENROLLMENTID, ACCOUNTSOURCEID, PAYROLL_DATE, CONTRIBUTION, INPUT_TYPE, INPUT_NAME, CREATED_BY, MODIFIED_BY, COMMENTS,CREATED,MODIFIED,PARENT_ID,BATCH_ID,EXPECTED_CONTRI,ROW_NUMBER,STATUS,ACCOUNT_VENDOR_PRODUCT_ID,REMITTANCE_TYPE,PAYROLL_SCHEDULE_ID,DISBURSEMENT_BATCH_ID,DISBURSEMENT_DATE, SPLIT_ACCOUNTENROLLMENTID, BATCH_PROCESS_DETAIL_ID, CHUNK_ID,CLM_CONFIGURATION_ID,FINAL_CONTRIBUTION,LIMIT_TYPE, INCOMING_CONTRIBUTION ) Values (?, ? , ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ,?, ?, ?);

select cx.client_xsid, px.plan_xsid, app.* from accountsprovidedproperties app 
join accountsprovided ap on ap.accountsprovidedid = app.accountsprovidedid
join clientxsmapping cx on ap.client_id = cx.client_id
join planxsmapping px on ap.accountsprovidedid = px.accountsprovidedid
where element like '%ADJUSTMENT_REPLACE%'
and (value = 'N' or value is null);

update accountsprovidedproperties set value = 'N' where element = 'ADJUSTMENT_REPLACE'; and value is null;
update ACCOUNTSPROVIDEDPROPERTIES set value = null where element = 'ADJUSTMENT_REPLACE' and value = 'Y';
select * from SOURCE_ENROLLMENT;

select * from accountenrollment;

select * from clientxsmapping cx join client c on c.id = cx.client_id
where client_xsid = '011119';
select * from planxsmapping;

select PS.* from PAYROLL_SCHEDULE PS
join CLIENTXSMAPPING CX on PS.CLIENT_ID = CX.CLIENT_ID
where CX.CLIENT_XSID = '553371'
and PS.START_FIN_YEAR <= '2014'
and PS.ENABLED = 'Y'
and PS.FREQUENCY = 26;

select distinct PS.PAYROLL_SCHEDULE_NAME, PS.START_FIN_YEAR, PS.ACCOUNTSPROVIDEDIDS,PX.PLAN_XSID, PS.PAYROLL_SCHEDULE_ID
from ACCOUNTSPROVIDED AP
join PAYROLL_SCHEDULE PS on PS.ACCOUNTSPROVIDEDIDS like CONCAT(CONCAT('%',AP.ACCOUNTSPROVIDEDID), '%')
join PLANXSMAPPING px on AP.ACCOUNTSPROVIDEDID = PX.ACCOUNTSPROVIDEDID
join CLIENTXSMAPPING CX on PS.CLIENT_ID = CX.CLIENT_ID
where CX.CLIENT_XSID = '553371'
and PS.START_FIN_YEAR <= '2014'
and PS.ENABLED = 'Y'
and PS.FREQUENCY = 26
order by PS.PAYROLL_SCHEDULE_NAME;


select * from PAYROLL_SCHEDULE_DATES where PAYROLL_SCHEDULE_ID = 'f695a0d305ae44ea8c5ec47a2ba648f7';
update payroll_schedule_dates set CR_sched_iD = null where PAYROLL_SCHEDULE_ID = 'f695a0d305ae44ea8c5ec47a2ba648f7' and fin_year = 2013; and seq in (1,2);

select * from SCHEDULE_INSTANCE where FILE_NAME_TEMPLATE like '%CR_054303_148974_148974_HOSWKY%';
insert into payroll_schedule (payroll_schedule_id, payroll_schedule_name, client_id ... <LIST of VALUES IN payroll_schedule>) 
values (select 'X', ps.payroll_schedule_name, ps.client_id ... from payroll_schedule ps where payroll_schedule_id = 'Y');
update schedule_instance set payroll_schedule_ids = 'X' where payroll_schedule_ids = 'Y';
update payroll_schedule_dates set payroll_schedule_id = 'X' where payroll_schedule_id = 'Y';
update payroll_schedule_dates set id = 'A' where id = 'B';
delete from payroll_schedule where payroll_schedule_id = 'Y';

select * from payroll_schedule_dates;
select * from schedule_instance;

select * from clientproperties where element = 'FILE_PRO_AL_ADJ';
select * from schedule_instance where file_name_template like '%054303%QUART%';
SAS_VERSION_2_4
update clientproperties set value = '2.0' where propertyid = '74b771916b804e238557fd7aad3dc592';element = 'FILE_PRO_AL_ADJ' and client_id = 481;
select * from clientxsmapping where client_xsid = '054303';
select qt.*,  si.schedule_id, qt.next_fire_time, si.file_name_template from schedule_instance si join qrtz_triggers qt on qt.job_name = schedule_id
where  si.schedule_id = '69c254c593384492a3f42f6a07c9ab96'
--and to_date(qt.next_fire_time, 'dd-mon-yyyy' ) > to_date('31-aug-2013','dd-mon-yyyy')
order by qt.trigger_name;
select * from QRTZ_TRIGGERS;
select * from payroll_schedule_dates; where payroll_schedule_id = '4e7fcf821bcc42988f2bdb74b66a8721';
select * from processstatus where processid = 44;

update tbljobqueue set complete = 1, locked = 0 where complete = 0;
update tbljobqueue set lastactivity = to_date('8-DEC-2013','dd-mon-yyyy') where lastactivity is null;
select * from Batch_failure order by modified_date desc;
select * from workflowheader order by lastactivity desc;
select Address_Addressid_seq.nextval from dual;
select * from address order by addressid desc; where addressid = 107702;
select * from payroll_hist;
select lc.* from location_customer lc join customer c on lc.customer_pk = c.pk
where c.username = '260260260';

select * from location_customer where location_id = 562 and customer_pk = 62624;
select * from location;
select * from masterproperties where element like '%BONUS%';
select * from clientproperties where element like '%BONUS%' and value = 'N';
select * from processstatus where processid = 10;
select * from batch_report order by created desc;

select * from employer_benefit;
select * from accountenrollment;
select c.username, px.plan_xsid,ms.sourcename, al.location_id, pyc.* from participant_ytd_contri pyc
join accountlocations al on al.id = pyc.accountlocation_id 
join planxsmapping px on px.accountsprovidedid = al.accountsprovidedid and px.xstype_id = 4
join customer c on c.customerid = pyc.customerid 
join accountsource asrc on asrc.accountsourceid = pyc.accountsourceid 
join mastersources ms on ms.mastersourcesid = asrc.mastersourcesid 
where
 c.username like '260260%'
 --and sourcename = 'E'
--and px.plan_xsid = '400044' and al.location_id = 607
order by pyc.customerid desc;

select * from employer_match 
where accountsprovidedid  = (Select Accountsprovidedid From Planxsmapping Where Plan_Xsid = '406326' and xstype_id = '4');



select * from location_customer;

select * from input_file order by create_date desc;

select * from LOCATIONXSMAPPING LX join location L on LX.LOCATION_ID = L.id where LOCATION_XSID = 'P673';
select * from CLIENTPROPERTIES CP
join CLIENTXSMAPPING CX on CX.CLIENT_ID = CP.CLIENT_ID
where CX.CLIENT_XSID = '011119';

select * from BATCH_PROCESS_DETAIL
where 1=1
--and LOCATION_ID = 690
--and PAYROLL_DATE is null
and BATCH_TYPE in ('ADJUSTMENT','COMBINED')
order by CREATE_DATE desc, row_number
;
select * from batch_report
where 1=1
--and LOCATION_ID = 690
--and PAYROLL_DATE is null
and REPORT_TYPE in ('VNDR_COMBINED_RPT','VNDR_COMBINED_RPT')
order by CREATED desc;, row_number
;
select * from client CP
join CLIENTXSMAPPING CX on CX.CLIENT_ID = CP.ID
where CX.CLIENT_XSID = '993370';

select * from payroll_input;
update CLIENTPROPERTIES set value = '1.0' where CLIENT_ID = 541 and element = 'GLOBAL_SPARK_VERSION';
select distinct element from masterproperties;
SELECT * FROM masterproperties where value like '%1.0%';
select * from clientproperties where element = 'GLOBAL_SPARK_VERSION';
update CLIENTPROPERTIES set value = '2.0' where element = 'GLOBAL_SPARK_VERSION';
select * from SCHEDULE_INSTANCE where FILE_NAME_TEMPLATE like '%P644%';
update schedule_instance set SOURCE_FILE_LAYOUT = 'TIAASPARKDefaultTemplateUUID' where SCHEDULE_ID = 'f9caf13863fc4cce9dbb9482be316911';

select * from payroll_schedule_dates where payroll_schedule_id = 'e404c7792ebf4a1c9b07ad9ad1e87f7c' and payroll_date = to_date('26-NOV-13');
select * from clientproperties where element like '%BONUS%' and client_id = 242;
update clientproperties set value = 'N' where element = 'CASH_BONUS_TYPE' and client_id = 242;
select ae.* from accountenrollment ae
where 1=1
and ae.customerid = '6b608a56da6e44e894f09a4141d3fc49'
--and ae.accountlocation_id = '6845' 
order by lastaccess desc;

select px.plan_xsid as PLANID, px.xstype_id, bpd.* 
from batch_process_detail bpd 
join customer c on c.customerid = bpd.customerid 
join accountlocations al on al.id = bpd.accountlocation_id 
join location_customer lc on lc.customer_pk = c.pk and lc.location_id = al.location_id 
join planxsmapping px on px.accountsprovidedid = al.accountsprovidedid 
where c.username = '303392019' and lc.location_id = 562 and px.xstype_id = 4 
--and bpd.batch_type = ? and bpd.remittance_Type = ? and bpd.payroll_date >=  ? and px.plan_xsid = ?  
;

select * from employer;
select * from location_customer lc;
select * from accountlocations;
select * from customer c where  c.username like '%78526%';

select * from participantdeferrals;
select * from accountenrollment; where customerid like '82553925ffa44816b97c0e3ec719306f';

select * from tblworkflowheaderproperty order by workflowid desc;

Select app.* from accountsprovided app where app.iserisa = 'N'; app.accountsprovidedid IN
select pxm.*, cxm.* from planxsmapping pxm
join clientxsmapping cxm on cxm.client_id = pxm.client_id
where pxm.accountsprovidedid = '0f412efa769b4ac7ab235cabf9bbbbc3';

select ap.description,app.* from accountsprovidedproperties app join accountsprovided ap on app.accountsprovidedid = ap.accountsprovidedid
where element like '%ADJUSTMENT_END_DATE_LOCATION%' and ap.description like '%NYU%';

update accountsprovidedproperties set value = 'ALTERNATE_VESTING_START_DATE' where propertyid = 'de2f4976a5be43c9b0064405dccef361';
select * from accountsprovided;



select c.username,ae.accountenrollmentid, lc.status as
employment_status,ap.description,ae.status,MS.SOURCENAME, pyc.contribution_ytd,fin_year, ap.accountsprovidedid, lc.* from CUSTOMER c
join ACCOUNTENROLLMENT ae on ae.customerid = c.customerid
join ACCOUNTLOCATIONS al on al.id = ae.accountlocation_id
join LOCATION_CUSTOMER lc on lc.customer_pk = c.pk and lc.location_id = al.location_id
join ACCOUNTSPROVIDED ap on ap.accountsprovidedid = ae.accountsprovidedid
join PARTICIPANT_YTD_CONTRI pyc on PYC.customerID = ae.customerid and pyc.accountlocation_id = ae.accountlocation_id
join ACCOUNTSOURCE asr on asr.accountsourceid = pyc.accountsourceid
join MASTERSOURCES ms on ms.mastersourcesid = asr.mastersourcesid
join EXTENDED_ATTRIBUTE ea on ea.parent_id = to_char(location_customer_id) and ea.parent_table = 'LOCATION_CUSTOMER' and ea.attribute_type = 'CLIENT_EMPLOYEE_ID'
where c.username = '260260100';

select * from participant_ytd_contri;
select * from payroll_product_split;

select unique c.username, c.firstname, c.lastname, pi.payroll_date, px.plan_xsid, ae.status 
from payroll_input pi 
join accountenrollment ae on pi.accountenrollmentid = ae.accountenrollmentid
join customer c on c.customerid = ae.customerid
join accountlocations al on al.id = ae.accountlocation_id
join planxsmapping px on px.accountsprovidedid = al.accountsprovidedid and px.xstype_id = 4
where 1=1
--and pi.input_name like '%CR_054303%'
and pi.payroll_date > to_date('21-JAN-2012','dd-mon-yyyy')
and pi.payroll_date < to_date('23-DEC-2012','dd-mon-yyyy')
and pi.input_type = 'COMBINED'
and px.plan_xsid in ('151576')
and ae.status in ('ELIGIBLE', 'ACTIVE')
--and c.username = '303392020'
order by c.username ,pi.payroll_date 
;
303392000, 1,2,3, 303392017, 303392042

select accountsprovidedid, count(location_id) as counts from accountlocations group by accountsprovidedid;
select * from location;

select C.Username, px.plan_xsid,m.sourcename,ap.description, ap.accountsprovidedid, se.* from source_enrollment se
join customer c on c.customerid = se.customerid
join accountenrollment ae on ae.customerid = se.customerid
Join Accountlocations Al On Al.Id = Se.Accountlocation_Id
join location_customer lc on lc.customer_pk = c.pk and lc.location_id = al.location_id 
join planxsmapping px on px.accountsprovidedid = al.accountsprovidedid and px.xstype_id = 4
Join Accountsource Asr On Asr.Accountsourceid = Se.Accountsourceid
Join Mastersources M On M.Mastersourcesid = Asr.Mastersourcesid
join accountsprovided ap on ap.accountsprovidedid = px.accountsprovidedid
Where C.Username like '708050302%'
--where lc.location_id = 1492 
order by se.create_date desc;

select lc.location_id, px.plan_xsid, ae.* from accountenrollment ae 
join accountlocations al on al.id = ae.accountlocation_id
join customer c on ae.customerid = c.customerid 
join location_customer lc on lc.customer_pk = c.pk and lc.location_id = al.location_id 
join planxsmapping px on px.accountsprovidedid = ae.accountsprovidedid and px.xstype_id = 4
where lc.location_id = 1495 
and C.Username = '708050302'
and ae.status = 'ACTIVE';


select sourcename, asr.* from accountsource asr
Join Mastersources M On M.Mastersourcesid = Asr.Mastersourcesid
where asr.accountsourceid in ('06e7ff2f7d56428d8391c3d0fe138658', '79c3f711732b49d3b3053fcbd4a3ed11', '8cc2e0cf898347a19ad12210e40e744a');

Select ap.description,Em.* ,
m_f_ee.sourcename as fixed_ee_sourcename,m_f_er.sourcename as fixed_er_sourcename,m_f_em.sourcename as er_match_sourcename,
m_f_eme.sourcename as ee_match_sourcename,
px.plan_xsid
from EMPLOYER_MATCH em 
left outer join matched_employee_sources mes on mes.employer_match_id = em.employer_match_id
left outer join accountsource a_f_ee on a_f_ee.accountsourceid = em.FIXED_EE_ACCOUNTSOURCEID    
left outer join accountsource a_f_er on a_f_er.accountsourceid = em.FIXED_ER_ACCOUNTSOURCEID  
left outer join accountsource a_f_em on a_f_em.accountsourceid = em.er_matched_accountsourceid 
left outer join accountsource a_f_eme on a_f_eme.accountsourceid = mes.MATCHED_EE_ACCOUNTSOURCEID 
left outer join mastersources m_f_ee on m_f_ee.mastersourcesid = a_f_ee.mastersourcesid   
left outer join mastersources m_f_er on m_f_er.mastersourcesid = a_f_er.mastersourcesid  
left outer join mastersources m_f_em on m_f_em.mastersourcesid =  a_f_em.mastersourcesid
left outer join mastersources m_f_eme on m_f_eme.mastersourcesid =  a_f_eme.mastersourcesid
Join Planxsmapping Px On Px.Accountsprovidedid = Em.Accountsprovidedid and px.xstype_id = 4
join accountsprovided ap on ap.Accountsprovidedid = px.Accountsprovidedid
Where 
px.plan_xsid = '991008';

(select sen.*, er_m_asr.accountsourceid as er_match_accountsourceid,er_m_master.sourcename as er_match_source,er_m_master.mastersourcesid as er_match_mastersourceid,em.fixed_ee_accountsourceid,em.fixed_er_accountsourceid from source_enrollment sen 
  join employer_match em on (em.fixed_ee_accountsourceid = sen.accountsourceid  or em.fixed_er_accountsourceid = sen.accountsourceid or em.er_matched_accountsourceid = sen.accountsourceid) 
  join accountsource er_m_asr on er_m_asr.accountsourceid = sen.accountsourceid 
  join mastersources  er_m_master on er_m_master.mastersourcesid = er_m_asr.mastersourcesid 
  where sen.customerid = 'dd2df3c3e61d43cc8348af4d553d3eab' and sen.accountlocation_id = 65631  )
  UNION (select sen.*, er_m_asr.accountsourceid as er_match_accountsourceid,er_m_master.sourcename as er_match_source,er_m_master.mastersourcesid as er_match_mastersourceid,em.fixed_ee_accountsourceid,em.fixed_er_accountsourceid from source_enrollment sen 
  Join Matched_Employee_Sources Mes On (Mes.Matched_Ee_Accountsourceid = Sen.Accountsourceid) 
  join employer_match em on mes.employer_match_id = em.employer_match_id 
 join accountsource er_m_asr on er_m_asr.accountsourceid = sen.accountsourceid 
  join mastersources  er_m_master on er_m_master.mastersourcesid = er_m_asr.mastersourcesid 
  where sen.customerid = 'dd2df3c3e61d43cc8348af4d553d3eab' and sen.accountlocation_id = 65631  );

select m.sourcename, px.plan_xsid, pi.payroll_date, sum(pv.contribution) as total_contribution
from payroll_product_split pv
join payroll_input pi on pi.payroll_input_id = pv.payroll_input_id
join accountenrollment ae on ae.accountenrollmentid = pi.accountenrollmentid
join customer c on c.customerid = ae.customerid
join accountsource acs on acs.accountsourceid = pi.accountsourceid
join mastersources m on m.mastersourcesid = acs.mastersourcesid
join accountlocations al on al.id = ae.accountlocation_id
join planxsmapping px on px.accountsprovidedid = al.accountsprovidedid and px.xstype_id = 4
where c.username = '567722207'
--and m.sourcename = ?
--and px.plan_xsid = ? and al.location_id = ?
group by pi.payroll_date, m.sourcename, px.plan_xsid
order by pi.payroll_date;

select * from locationxsmapping;
select * from planxsmapping;
select location_id from accountsprovided where description like '%NYU School of Medicine 403(B) Retirement Plan%';
select plan_xsid from accountsprovided;
select * from payroll_input;

  SELECT workflowid, element, propertyvalue FROM TBLWORKFLOWHEADERPROPERTY WHERE workflowid in ('313762', '313763', '313673') and element in ('STAC_SERVICE');
  
  select * from payroll_input where input_name = 'CR_003878_100051_100051_ARGWK_130822_100000.txt';
  
  select er.*,ex.employer_xsid from employer er 
 join employerxsmapping ex on ex.employer_id = er.id 
 join clientxsmapping cx on cx.client_id = er.client_id;
  
select C.LASTNAME, C.FIRSTNAME, C.MIDDLENAME, EA.ATTRIBUTE_VALUE, CR.PLAN_NUMBERS, CR.FIN_YEAR, CR.limit, CR.YTD_CONTRI_ER, CR.YTD_CONTRI_EE, CR.YTD_CONTRI_PAST, 
CR.ORIG_CONTRI_ER, CR.ORIG_CONTRI_EE, CR.ADJ_CONTRI_ER, CR.EXCEEDED_AMOUNT, CR.ADJ_CONTRI_EE, CR.CLIENT_ID, CR.EMPLOYER_ID, 
CR.LOCATION_ID, CR.IS_MULT_LOC_ENROLL,CX.CLIENT_XSID, EX.EMPLOYER_XSID, LX.LOCATION_XSID, CR.CONTRIBUTION_SOURCES, 
CLMC.LIMIT_START_DATE, CLMC.LIMIT_END_DATE, CLMC.CALENDAR_YEAR, CR.LIMIT_TEST_NAME 
from COMPLIANCE_RESULT CR 
join CUSTOMER C ON C.CUSTOMERID = CR.CUSTOMER_ID 
join LOCATION_CUSTOMER LC on LC.CUSTOMER_PK = C.PK AND LC.LOCATION_ID = CR.LOCATION_ID 
join EXTENDED_ATTRIBUTE EA on EA.PARENT_TABLE = 'LOCATION_CUSTOMER' and EA.PARENT_ID = LC.LOCATION_CUSTOMER_ID and EA.ATTRIBUTE_TYPE = 'CLIENT_EMPLOYEE_ID' 
join CLIENTXSMAPPING CX on CX.CLIENT_ID = CR.CLIENT_ID 
join EMPLOYERXSMAPPING EX on EX.EMPLOYER_ID = CR.EMPLOYER_ID 
join LOCATIONXSMAPPING LX on LX.LOCATION_ID = CR.LOCATION_ID 
left outer join CLM_CONFIGURATION CLMC on CLMC.CLM_CONFIGURATION_ID = CR.CLM_CONFIGURATION_ID 
--where CR.CLIENT_ID = ? and CR.EMPLOYER_ID = ? and CR.LOCATION_ID = ? and CR.BATCH_ID = ? 
where CR.EXCLUDE is null and CR.REPORT_TYPE = 'CONTRI_ADJUSTMENT_RPT'
order by CR.LIMIT desc, C.LASTNAME, C.FIRSTNAME, C.MIDDLENAME, C.USERNAME;
  
  
  
select PLAN_NUMBER, 
 C.LASTNAME, C.FIRSTNAME, C.MIDDLENAME ,SOURCENAME, 
 C.USERNAME, EA.ATTRIBUTE_VALUE as IPIN, 
 L.id as LOCATION_ID,E.id as EMPLOYER_ID,E.CLIENT_ID as CLIENT_ID, 
 ADJUSTMENT_CONTRIBUTION,CONTRIBUTION_YEAR, LX.LOCATION_XSID 
 from
 (select PX.PLAN_XSID as PLAN_NUMBER,MS.SOURCENAME,TO_CHAR(P.PAYROLL_DATE,'YYYY') as CONTRIBUTION_YEAR,
 SUM(PVS.CONTRIBUTION) as ADJUSTMENT_CONTRIBUTION,LC.LOCATION_CUSTOMER_ID as LOC_CUST_ID
 from PAYROLL_INPUT P 
 join PAYROLL_PRODUCT_SPLIT PVS on PVS.PAYROLL_INPUT_ID = P.PAYROLL_INPUT_ID 
 join ACCOUNTSOURCE ASR on ASR.ACCOUNTSOURCEID = P.ACCOUNTSOURCEID 
 join MASTERSOURCES MS on MS.MASTERSOURCESID = ASR.MASTERSOURCESID 
 join ACCOUNTENROLLMENT AE on AE.ACCOUNTENROLLMENTID = P.ACCOUNTENROLLMENTID 
 join ACCOUNTSPROVIDED AP on AE.ACCOUNTSPROVIDEDID = AP.ACCOUNTSPROVIDEDID 
 join CUSTOMER C on C.CUSTOMERID = AE.CUSTOMERID 
 join PLANXSMAPPING PX on AE.ACCOUNTSPROVIDEDID = PX.ACCOUNTSPROVIDEDID and PX.XSTYPE_ID = 4 
 join ACCOUNTLOCATIONS AL on AL.id = AE.ACCOUNTLOCATION_ID 
 join LOCATION_CUSTOMER LC on LC.CUSTOMER_PK = C.PK and LC.LOCATION_ID = AL.LOCATION_ID
 where--P.DISBURSEMENT_BATCH_ID = ? 
 --and 
 P.PARENT_ID is null 
 and P.INPUT_TYPE = 'MANUAL_ADJUST'
 group by 
 LC.LOCATION_CUSTOMER_ID,PX.PLAN_XSID,MS.SOURCENAME,TO_CHAR(P.PAYROLL_DATE,'YYYY')
 )
 join LOCATION_CUSTOMER LC2 on LC2.LOCATION_CUSTOMER_ID = LOC_CUST_ID
 join LOCATIONXSMAPPING LX on LC2.LOCATION_ID = LX.LOCATION_ID 
 join location L on L.id = LC2.LOCATION_ID 
 join EMPLOYER E on E.id = L.EMPLOYER_ID 
 left outer join EXTENDED_ATTRIBUTE EA on TO_CHAR(LC2.LOCATION_CUSTOMER_ID) = EA.PARENT_ID 
 and UPPER(EA.PARENT_TABLE) = 'LOCATION_CUSTOMER' 
 and UPPER(EA.ATTRIBUTE_TYPE) = 'CLIENT_EMPLOYEE_ID' 
 join CUSTOMER C on C.PK = LC2.CUSTOMER_PK
 where c.username = '587777905'
ORDER by PLAN_NUMBER, C.LASTNAME, C.FIRSTNAME;

select * from PAYROLL_INPUT where INPUT_TYPE = 'MANUAL_ADJUST'
and PARENT_ID is not null;

select * payro;

select * from PAYROLL_INPUT PI join
PAYROLL_INPUT PI2 on PI.PARENT_ID = PI2.PAYROLL_INPUT_ID
where pi.INPUT_TYPE = 'MANUAL_ADJUST';

  
  
  select pp.* from PAYROLL_PER_PAY_COMP pp
  join PAYROLL_HIST PH on PH.PAYROLL_HIST_ID = PP.PAYROLL_HIST_ID
  where PH.LOCATION_CUSTOMER_ID = 72885 and PP.BATCH_ID = 'b270e1f7e66a43338e82b11e3dce88fd'
  order by pp.payroll_date desc;
  
  
  b270e1f7e66a43338e82b11e3dce88fd
  
  
 -- 97,970,Seed File Test,FILENAME=S_011119_100378_100378_121210_050801.txt|FILELOCATION=/home/tester1/local/inbound/011119/S/processed|FILETYPE=SEED