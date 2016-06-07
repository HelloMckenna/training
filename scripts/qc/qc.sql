select drs.id, tnames.tname, tnames.valid_id, drs.latitude, drs.longitude, drs.qc
from obis.drs
left join obis.snames
on drs.sname_id = snames.id
left join obis.tnames
on snames.tname_id = tnames.id
where tnames.valid_id = 628517 