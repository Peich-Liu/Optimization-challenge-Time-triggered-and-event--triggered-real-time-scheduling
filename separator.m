function [TT_task_table,ET_task_table] = separator(file_path)%file version 0.1.2 updated 1013
%0.1.2更新：将除了name以外的所有数组更改为double类型
%此处输入的file_path是基于macOS调试的，理论上支持Windows，格式为'/Users/desktop/test'类似
cd(file_path);%切换到文件路径，如出错可以自行修改为cd('测试文件夹')然后把上面的输入给删掉
namelist=dir('*.csv');%遍历文件夹内的所有csv然后返回名单
len=length(namelist);%获取文件个数
for i=1:len
    file{i}=namelist(i).name;%获取第I个文件的名字并在导入
    task(i)=importdata(file{i});%这个方法会默认把文字和数字分成两个部分，在实际操作中是cell和double的分类
    [r,c]=size(task(i).textdata);%其中一个表的名字是textdata，另一个是data，这里获取是textdata的长度，宽度用不到
    for j=1:r
        if (strcmp(task(i).textdata(j,5),'ET'))%变相将一个类指针的东西指向第一个ET数据然后分类
            break;
        end
    end
    A(i).Duration=task(i).textdata(2:j-1,3);
    A(i).Period=task(i).textdata(2:j-1,4);
    B(i).Duration=task(i).textdata(j:r,3);
    B(i).Period=task(i).textdata(j:r,4);


    TT_task_table(i).Name=task(i).textdata(2:j-1,2);
    TT_task_table(i).Priority=task(i).data(1:j-2,1);
    TT_task_table(i).Deadline=task(i).data(1:j-2,2);
    ET_task_table(i).Name=task(i).textdata(j:r,2);
    ET_task_table(i).Priority=task(i).data(j-1:r-1,1);
    ET_task_table(i).Deadline=task(i).data(j-1:r-1,2);
    %convertor%
    for c=1:30
        TT_task_table(i).Duration(c)=str2num(A(i).Duration{c});
        TT_task_table(i).Period(c)=str2num(A(i).Period{c});
    end
    for c=1:20
        ET_task_table(i).Duration(c)=str2num(B(i).Duration{c});
        ET_task_table(i).Period(c)=str2num(B(i).Period{c});
    end
end

end