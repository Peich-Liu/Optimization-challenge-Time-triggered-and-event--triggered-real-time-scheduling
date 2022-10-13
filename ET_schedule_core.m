function [ET_response_time,ET_result] = ET_schedule_core(et)
% output:ET_is_schedule,ET_WCRT
% input:ET_task_table,polling_server_setting
%%initial
task = [ET_task_table: polling_server_setting];
duration = task( :1);
period = task( :2);
priority = task( :4);
deadline = task(:5);
computation = duration;%?
delta = et.Period + et.Deadline - 2*et.Duration;
alpha = et.Duration / et.Period;
%%algorithm
T = period(1);
for i = 2:length(period)
    T = lcm(T,period(i));
end

for i = 1:size(task,1)
    t = 0;
    ET_response_time = deadline*(i) + 1;
    %1
    while (t<=T)
    supply = alpha * (t - delta(i));%1111
    demand = 0;
        for j = 1:size(task,1)
            if priority(j) >= priority(i)
            demand = demand + (t / period(j)) * computation(j);
            end
        end
        if supply >= demand
            ET_response_time = t;
            break;
        end
        t = t + 1;
        if ET_response_time > deadline(i)
            ET_result = 0;
            return 
        end
    end
    ET_result = 1;
end
