function [ET_response_time,ET_result] = ET_schedule_core(et)
%%% output:ET_is_schedule,ET_WCRT
%%% input:ET_task_table,polling_server_setting 
ET_response_time(size(et,2)) = 0;
ET_result(size(et,2)) = 0;
for m = 1:size(et,2)
delta = transpose(et(m).Period) + et(m).Deadline - 2.*transpose(et(m).Duration);
alpha = transpose(et(m).Duration) ./ transpose(et(m).Period);
T = transpose(et(m).Period(1));
for i = 2:length(transpose(et(m).Period))
    T = lcm(T,transpose(et(m).Period(i)));
end
for i = 1:size(et(m).Name,1)
    t = 0;
    ET_response_time(m) = et(m).Deadline(i) + 1;
    %1
    while (t<=T)
    supply = alpha(i) * (t - delta(i));%1111
    demand = 0;
        for j = 1:size(et(m).Name,1)
            if et(m).Priority(j) >= et(m).Priority(i)
            demand = demand + (t / transpose(et(m).Period(j))) * transpose(et(m).Duration(j));
            end
        end
        if supply >= demand
            ET_response_time(m) = t;
            break;
        end
        t = t + 1;
        if ET_response_time(m) > et(m).Deadline(i)
            ET_result(m) = 0;
        end
    end
    ET_result(m) = 1;
end
end
