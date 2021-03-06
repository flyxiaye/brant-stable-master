% % %--------------------------------------------------------------------
% % %                          Hurst.m
% % %--------------------------------------------------------------------

clear all
clc
tic
fprintf('Start now...\n');
toolboxDir ='/home/yliu/Desktop/CCM_SPM_Batch09/';
workpath = '/DATA/243/yliu/PreProc/'; % path for your uselist
filelist = textread([workpath,'/subjlist.txt'],'%s'); %%% the subject list

%%
targetpath =strcat([ '/home/yliu/Desktop/Series/fGn/']);

mkdir(targetpath);

%%
MeanType = 'RHLWC';
VoxelSize = 2;
timeLength = 1200;


addpath(toolboxDir);
%%%%%%% end of modify %%%%%%
if VoxelSize ==2
    maskName = strcat(toolboxDir,'/maskEPI_V2mm.img');
    Row = 91;Col = 109;Slice = 91;
    volumesize = [91 109 91];
elseif VoxelSize == 3
    maskName = strcat(toolboxDir,'/maskEPI_V3mm.img');
    Row = 61;Col = 73;Slice = 61;
    volumesize = [61 73 61];
end
%%% default

%%%%
SubjectNum = length(filelist);
fprintf('Begin to estimate teh b1,b2, and H0\n');
[b1,b2,H0,alpha]  =  Truncated_Alpha(timeLength);
%-------------------------Reho------------------------%
Hurst = zeros (Row, Col, Slice);
Sigma = zeros (Row, Col, Slice);

V = spm_vol(maskName);
[Mask,v]= spm_read_vols(V);
fid = fopen('log.txt','a+');

  for SubjectNo =99: SubjectNum
    %--------read fMRI Data-----------%
    SubjectNo
    tic;
    
    %     fprintf('Begin to mean  %s... \n',filelist{i});
    file = dir([filelist{SubjectNo},'/',MeanType,'*.nii']);
    s= strcat(['Img file number is ',num2str(length(file))]);
     fprintf(fid,s);
fprintf(fid,'\n');
    %             error('pls check the subject Num');
    %         end
    TC_total= zeros(Row,Col,Slice,length(file));
    for j = 1:length(file)
        filename = [filelist{SubjectNo},'/',file(j).name];
        V = spm_vol(filename);
        [Outdata,XYZ] = spm_read_vols(V);
        
        Outdata = Outdata.*Mask;
        TC_total(:,:,:,j)  = Outdata;
        
        
        
    end
    
    clear DataTmp;
    %--------------Reho------------%
    timeLength = length(file);
    for RowTmp = 1 : Row
        for ColTmp = 1 : Col
            for SliceTmp = 1 : Slice
                if (Mask(RowTmp, ColTmp, SliceTmp) > 0)
                    s = squeeze(TC_total (RowTmp, ColTmp, SliceTmp, :));
                    [H,sigma,f,Sf]  =  MPE0(s,timeLength,b1,b2);
                    Hurst(RowTmp, ColTmp, SliceTmp) = H;
                    Sigma(RowTmp, ColTmp, SliceTmp) = sigma;
                end
            end
        end
    end
    
    clear Data;
    %-----------------save Hurst-----------%
    [P nm2] = fileparts(fileparts(filelist{SubjectNo}));
    [P nm1] = fileparts(P);
    fileName = strcat(targetpath,nm1,'_',nm2,'_H.nii');
    V.fname = fileName;
    spm_write_vol(V,Hurst);
    fileName = strcat(targetpath,nm1,'_',nm2,'_Sigma.nii');
    V.fname = fileName;
    spm_write_vol(V,Sigma);
    
    toc;
end
fclose all;

exit;

