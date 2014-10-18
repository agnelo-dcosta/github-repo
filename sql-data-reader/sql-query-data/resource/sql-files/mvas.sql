
--Connection CR

--ec employer contribution
select px.plan_xsid,ms.SOURCENAME,ec.CONTRIBUTION_RATE,ec.CONTRIBUTION_TYPE,ec.BENEFIT_DATE,ec.RATE_LAST_PERIOD from employer_contribution ec 
join accountsource asrc on asrc.accountsourceid = ec.ACCOUNTSOURCEID
join mastersources ms on ms.mastersourcesid = asrc.mastersourcesid 
join accountlocations al on al.id = ec.ACCOUNTLOCATIONS_ID
join planxsmapping px on px.accountsprovidedid = al.ACCOUNTSPROVIDEDID
join customer c on c.customerid = ec.customerid 
where c.username = '$SSN';

#2
--plan feedback 
select ae.FEEDBACK_INELIG_SEND_FLAG,ae.FEEDBACK_INCLUDED_DATE,ae.FEEDBACK_INELIG_SENT_DATE, ae.status,px.plan_xsid, ms.sourcename, ae.submitted_date, ae.ACCOUNTLOCATION_ID,ae.ACCOUNTSPROVIDEDID, pd.* from participantdeferrals pd 
join accountenrollment ae on ae.accountenrollmentid = pd.accountenrollmentid 
join accountsource asrc on asrc.accountsourceid = pd.accountsourceid 
join planxsmapping px on px.accountsprovidedid = asrc.accountsprovidedid and px.xstype_id = 4
join mastersources ms on ms.mastersourcesid = asrc.mastersourcesid 
join customer c on c.customerid = ae.customerid 
where  c.username = '$SSN'; and ae.status = 'ACTIVE';

-- contribution limits 
select c.username, e.client_id, px.plan_xsid,ms.sourcename, pyc.* from participant_ytd_contri pyc
 join accountlocations al on al.id = pyc.accountlocation_id 
 join planxsmapping px on px.accountsprovidedid = al.accountsprovidedid and px.xstype_id = 4
 join accountsprovided ap on ap.accountsprovidedid = al.accountsprovidedid
 join customer c on c.customerid = pyc.customerid 
 join accountsource asrc on asrc.accountsourceid = pyc.accountsourceid 
 join mastersources ms on ms.mastersourcesid = asrc.mastersourcesid
 join location l on l.id = al.location_id 
join employer e on e.id = l.employer_id
where c.username = '$SSN' ; 
 
 --benefit date 
 select c.username, ec.benefit_date, ec.contribution_rate, ec.last_benefit_fb_sent, ec.rate_last_period, ms.sourcename , ms.sourcetypedesc , acc.match_type  
from customer c join employer_contribution ec on ec.customerid = c.customerid
join accountsource acc on ec.accountsourceid = acc.accountsourceid
join mastersources ms on acc.mastersourcesid = ms.mastersourcesid
where c.username = '$SSN';


--accountenrollment details 
select ae.status, cxs.client_xsid, exs.employer_xsid, lxs.location_xsid, cust.username as $SSN, pxs.plan_xsid, ap.description, cust.customerid, cxs.client_id, ae.accountlocation_id, 
a.parentid,cp.edelivery_pref, cxs.client_id, lc.status_effective_date, ap.description, ae.accountenrollmentid, ap.accountsprovidedid, lc.location_customer_id, 
lc.emp_type, lc.hr_subarea, cust.customerid, ae.effective_start_date,ae.lastaccess,ae.modified_by, ae.created_by, cust.Date_of_birth as DOB, lc.payroll_freq,lc.Years_service as YS, lxs.location_xsid as LOC_CODE, 
exs.employer_xsid as EMP_CODE, cxs.client_xsid as CLI_CODE, AE.STATUS as STATUS, AE.ACCOUNTENROLLMENTID as MVAS_OSDA_ID, lc.subtype, a.*
from customer cust
join accountenrollment ae on ae.customerid = cust.customerid
join accountsprovided ap on ap.accountsprovidedid = ae.accountsprovidedid
join location_customer lc on cust.pk = lc.customer_pk
join planxsmapping pxs on pxs.accountsprovidedid = ap.accountsprovidedid
join employer_customer ec on ec.customerid = cust.customerid
join locationxsmapping lxs on lxs.location_id = lc.location_id
join employerxsmapping exs on exs.employer_id = ec.employer_id
join clientxsmapping cxs on cxs.client_id = exs.client_id
join address a on a.parentid=to_char(lc.location_customer_id) and a.parenttable = 'LOCATION_CUSTOMER'
join CUSTOMER_PREFS CP on cp.customerid = cust.customerid
where pxs.xstype_id = 4
and cust.username = '$SSN' order by ae.lastaccess desc;

--PPC in MVAS
select ph.*, pppc.*, lc.* from payroll_hist ph
join payroll_per_pay_comp pppc on pppc.payroll_hist_id = ph.payroll_hist_id
join location_customer lc on lc.location_customer_id = ph.location_customer_id
join customer cust on cust.pk = lc.customer_pk
where cust.username = '$SSN' order by pppc.payroll_date desc;

