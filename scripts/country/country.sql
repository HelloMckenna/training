with eezs as (
	select id, eez, country, sovereign
	from geo.eezs
	where country like '%Belgium%' -- also try eez or sovereign
)
select 
	tr30.tname as phylum,
	tr60.tname as class, 
	tr100.tname as order, 
	tr140.tname as family, 
	tr180.tname as genus, 
	tr220.tname as species, 
	p.id, 
	p.resource_id, 
	p.latitude, 
	p.longitude, 
	p.datecollected,
	extract(year from datecollected) as year
from portal.points_ex p
left join obis.tnames t on t.id = p.valid_id
inner join eezs on p.eez_id = eezs.id
inner join obis.flatclassification on flatclassification.id = t.id
left join obis.tnames tr30 on flatclassification.r30 = tr30.id
left join obis.tnames tr60 on flatclassification.r60 = tr60.id
left join obis.tnames tr100 on flatclassification.r100 = tr100.id
left join obis.tnames tr140 on flatclassification.r140 = tr140.id
left join obis.tnames tr180 on flatclassification.r180 = tr180.id
left join obis.tnames tr220 on flatclassification.r220 = tr220.id
where tr30.tname is not null
order by p.tname;