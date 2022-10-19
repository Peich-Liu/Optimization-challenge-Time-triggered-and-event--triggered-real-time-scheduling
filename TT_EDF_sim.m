function [schedule_table,WCRT,result] = TT_EDF_sim(tt)
%% Initial
t = 0;
result = [];
m = 1;
c = transpose(tt(m).Duration);
d = tt(m).Deadline;
WCRT = zeros(1,size(tt(m).Name,1));
r = zeros(1,size(tt(m).Name,1));
    %lcm computing
T = transpose(tt(m).Period(1));
for i = 2:length(transpose(tt(m).Period))
    T = lcm(T,transpose(tt(m).Period(i)));   
end
%schedule_table initial
schedule_table = zeros(T,2);%expand?
schedule_table(:,2) = 1:T;
    
while (t<T)
    for i = 1:size(tt(m).Name,1)
        if c(i)>0 && d(i) <=t    
            result = "Deadline miss!";
            disp(result)
            return
        end
        if transpose(tt(m).Duration(1)) == 0 && d(i)>=t %%??????
            if t - r(i)>= WCRT(i)
                WCRT(i) = t- r(i);
            end
        end
        if mod(t,transpose(tt(m).Period(i))) == 0
            r(i) = t;
            c(i) = transpose(tt(m).Duration(i));
            d(i) = tt(m).Deadline(i) + t;
        end
    end
    if sum(c) == 0   
        schedule_table(t+1,2) = "idle";
    else
        j = EDF(t,d,c);
        schedule_table(t+1,2) = j;
        c(j) = c(j)-1;
    end
    t = t + 1;
end
if sum(c)>0
    result = "Schedule is infeasible!";
    return 
end
% end
%return