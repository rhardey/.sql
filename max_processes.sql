col resource_name  format a15 heading "Parameters"
col max_utilization        format 99999    heading "Max Value Reached"
col current_utilization    format 99999    heading "Current Value"
col initial_allocation     format a10       heading "SPFILE Value"

SELECT upper(resource_name) as resource_name,current_utilization,max_utilization,initial_allocation
FROM v$resource_limit WHERE resource_name in ('processes', 'sessions')
/
