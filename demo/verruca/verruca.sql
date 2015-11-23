with taxon as (
    select id, storedpath
    from obis.tnames
    where tname = 'Verruca stroemia'
)
select t.tname as accepted, drs.qc, p.*
from portal.points_ex p
left join obis.tnames t
on t.id = p.valid_id
inner join taxon
on t.id = taxon.id or t.storedpath like taxon.storedpath || taxon.id || 'x%'
left join obis.drs
on drs.id = p.id
order by p.tname;