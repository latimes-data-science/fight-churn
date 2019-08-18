with num_metric as (
	select account_id, metric_time, metric_value as num_value
	from metric m inner join metric_name n on n.metric_name_id=m.metric_name_id
	and n.metric_name = 'NUM_METRIC'
	and metric_time between 'FRYR-MM-DD' and 'TOYR-MM-DD'
), den_metric as (
	select account_id, metric_time, metric_value as den_value
	from metric m inner join metric_name n on n.metric_name_id=m.metric_name_id
	and n.metric_name = 'DEN_METRIC'
	and metric_time between 'FRYR-MM-DD' and 'TOYR-MM-DD'
)
select d.account_id, d.metric_time, num_value, den_value,
	case when den_value > 0
	    then coalesce(num_value,0.0)/den_value
	    else 0
    end as metric_value
from den_metric d  left outer join num_metric n
	on n.account_id=d.account_id
	and n.metric_time=d.metric_time;
