function task_index = EDF(t,deadline,computation)
index1 = computation>0;
index2 = deadline>t;
index = intersect(index1,index2);
[min_deadline,task_index] = min(deadline(index));     