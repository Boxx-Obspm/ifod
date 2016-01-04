function [Mat_err]=Error()
	Mat_err=[]
	for ii=1:1:900
		[CHI2,diff,A,B]= visualization_prog(ii);
		Mat_err=[Mat_err, norm(diff)];
	endfor
	dlmwrite("/home/tristan/Documents/dlmwrite",Mat_err')
end