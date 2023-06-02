function Holzer_PSD_v03

%particle/pore size distribution adopted from Holzer's paper
%3D version
%add excel output
%modified for R2012a
%normalized to radius to avoid difference between different radius

close all;
clear all;
imtool close all;

input_data_dimension = 3;  %input fild: 3= one single multiple page tiff file; 2= slices of tif file

% for NiYSZ 65:35 coarsening

%%%%%%%%%%%%%%USER DEFINE!!!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%input file information 

%inpath =  'D:\YuChungLin\Henkel_die_attachment\analyze_cSAXS\SampleC3\Avizo\'
%prefix = 'C3_raw_178-631_crop_to-byte'

%inpath =  'D:\YuChungLin\Henkel_die_attachment\analyze_cSAXS\Sample2\Avizo\'
%prefix = 'S2_raw_crop_to-byte_interpolate'


%inpath =  'D:\YuChungLin\Henkel_die_attachment\analyze NSLS-TXM\Sample_B1\Avizo\'
%prefix = 'SB1_raw_crop_to-byte'

%inpath =  'D:\YuChungLin\Henkel_die_attachment\analyze_cSAXS\SampleC3\Avizo\'
%prefix = 'C3_raw_178-631_crop_erodedilate_to-byte'

%inpath =  'D:\YuChungLin\Henkel_die_attachment\analyze_cSAXS\SampleC3\Avizo\'
%prefix = 'C3_raw_178-631_crop_histogram_erodedilate_1_final_to-byte'



%inpath =  'D:\YuChungLin\Henkel_die_attachment\analyze_cSAXS\Sample7\avizo\'
%prefix = 'S7_raw_x-3_63-420_crop_porosity_to-byte'

%inpath =  'D:\YuChungLin\Henkel_die_attachment\analyze NSLS-TXM\Sample_B1\Avizo\'
%prefix = 'SB1_raw_crop_to-byte'

% inpath =  'D:\YuChungLin\Henkel_die_attachment\analyze_cSAXS\Sample8\Avizo\'
% prefix = 'S8_raw_crop_histogram_separatepahse_interpolate_1_to-byte'

%inpath =  'D:\YuChungLin\Henkel_die_attachment\analyze_cSAXS\Sample7\avizo\'
%prefix = 'S7_raw_x-3_63-420_crop_porosity_interpolate_to-byte'

 inpath =  'E:\Xiaoyang\tomviz_test\'
 prefix = '050_testfortomviz'


phase_name = 'cluster'
phase = 255;


%voxel_size = 20.28 ;  %need to match the actual data - reconstruction voxel size is 2x of raw data (bin=2 in recon)
voxel_size = 52.32;  %need to match the actual data - reconstruction voxel size is 2x of raw data (bin=2 in recon)
%voxel_size = 19.45 ;  %need to match the actual data - reconstruction voxel size is 2x of raw data (bin=2 in recon)
% 
%for Sample A particle
file_beg = 1;
file_end = 447; %number of images in the image stack
file_x = 340;
file_y = 365;


% %for Sample B1 pore
% file_beg = 1;
% file_end = 1010; %number of images in the image stack
% file_x = 458;
% file_y = 446;

%for Sample B1 silver
%file_beg = 1;
%file_end = 1010; %number of images in the image stack
%file_x = 458;
%file_y = 446;

% for Sample C3 silver
%file_beg = 1;
%file_end = 454; %number of images in the image stack
%file_x = 644;
%file_y = 618;

% for Sample C3 pore
%file_beg = 1;
%file_end = 454; %number of images in the image stack
%file_x = 644;
%file_y = 618;

% for Sample C3 silver
%file_beg = 103;
%file_end = 454; %number of images in the image stack
%file_x = 644;
%file_y = 618;


% for Sample 8 pore
% file_beg = 1;
% file_end = 631; %number of images in the image stack
% file_x = 484;
% file_y = 478;

% for Sample 8 pore
%file_beg = 1;
%file_end = 340; %number of images in the image stack
%file_x = 484;
%file_y = 478;

%for Sample 8 silver
%file_beg = 1;
%file_end = 631; %number of images in the image stack
%file_x = 484;
%file_y = 478;


%for Sample 2 pore
%file_beg = 1;
%file_end = 311; %number of images in the image stack
%file_x = 473;
%file_y = 376;

%for Sample 2 pore interface
%file_beg = 17;
%file_end = 311; %number of images in the image stack
%file_x = 473;
%file_y = 376;


%for Sample 2 silver
%file_beg = 1;
%file_end = 311; %number of images in the image stack
%file_x = 473;
%file_y = 376;

%for Sample 7 pore
%file_beg = 1;
%file_end = 358; %number of images in the image stack
%file_x = 330;
%file_y = 387;

%for Sample 7 silver
%file_beg = 1;
%file_end = 358; %number of images in the image stack
%file_x = 330;
%file_y = 387;

%for Sample 7 pore
%file_beg = 77;
%file_end = 358; %number of images in the image stack
%file_x = 330;
%file_y = 387;


%output file information
rs_step = 1
factor = 1
outpath = inpath
outprefix = [prefix, 'withNorm_rs_', num2str(rs_step), '_factor_', num2str(factor)]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

textname = ['PSD_',outprefix];
excelfile = [outpath, textname, '.xlsx']
textfile = [outpath, textname, '.txt']
sheet_name = phase_name

matfile_name = [outpath, textname, phase_name, '.mat']

%loading the imges
file_z = file_end - file_beg+1; %need modify!!
img = uint8(zeros(file_y,file_x,file_z));

switch input_data_dimension 
    case 3

        %for 3D data set
        for i=1:file_z
            img(:,:,i) = imread([inpath,prefix,'.tif'],i);
        end
        
    case 2
        %for 2D slices data set

        for i=1:file_z
            k=file_beg-1+i;
            if k >99
                num = num2str(k);
            else if k>9
                    num = ['0',num2str(k)];
                else
                    num = ['00',num2str(k)];
                end
            end
            
            img(:,:,i) = imread([inpath,prefix,num],'tiff');
        end
        
        

end
xsize=int16(file_x*factor)
ysize=int16(file_y*factor)
zsize=int16(file_z*factor)
%file_y,file_x,file_z

yred = int16(ysize*(1-factor)/2)
xred = int16(xsize*(1-factor)/2)
zred = int16(zsize*(1-factor)/2)

img = img(1+yred:ysize+yred, 1+xred:xsize+xred, 1+zred:zsize+zred);

imtool(img(:,:,1));
%imtool(img(:,:,2));

%build distance map and remove the Nan
interest = img == phase;
sum_interest = sum(interest(:))

outside = ~interest; 
imtool(interest(:,:,1));
imtool(outside(:,:,1));

%dilate 'outside'
method = 'quasi-euclidean';
SE_outside = logical (ones(3,3,3));
outside = imdilate(outside,SE_outside);

method = 'quasi-euclidean';
dist_map = bwdistgeodesic(interest, outside, method);   %core: building the map
dist_map(isnan(dist_map))=0;
imtool(dist_map(:,:,1));
a='done with dilate'

rs_array = 1:rs_step:max(dist_map(:))

for i=1:size(rs_array,2)
rs = double(rs_array(i))    
R_rs = dist_map >= rs;  % select the region with distance >= rs
%imtool(R_rs(:,:,1));
count_Rrs = sum(R_rs(:));

%generate the structing element for dialation
%approx_fac = 0 %approximation factor; see strel for more details
%SE = strel('disk', rs, approx_fac); %disk for 2D case
%SE = ones(3,3,3);
%SE = strel('ball', rs, rs*2, approx_fac) %ball for 3D case - doens't
%work..
method = 'quasi-euclidean';
SE = logical (ones(rs*2+1,rs*2+1,rs*2+1));
mid = rs+1;
SE(mid,mid,mid) = false; 
mask = ~SE;
SE_outside = logical (ones(3,3,3));
mask = imdilate(mask,SE_outside);

dist_SE = bwdistgeodesic(SE, mask, method);
dist_SE(isnan(dist_SE))= 0;
SE (dist_SE > rs) = 0;
SE(mid,mid,mid) = 1;

Rrs_dil = imdilate(R_rs,SE) & interest;
%R_rs = Rrs_dil - R_rs
%imtool(R_rs(:,:,1));
Rrs_dil_count(i) = sum(Rrs_dil(:)) - count_Rrs

save(matfile_name, 'Rrs_dil_count', 'rs_array')

end

%total_Rrs_count = sum(Rrs_dil_count)
%Rrs_vol_fraction = Rrs_dil_count./total_Rrs_count;

rs_array_nm = rs_array.*voxel_size*2  %diameter in nm
Rrs_vol_accum = Rrs_dil_count.*(voxel_size^3)./1000./1000./1000
plot(rs_array_nm, Rrs_vol_accum)  %need to be outputted
xlabel('Feature Diameter (nm)');
ylabel('Volume (micron^3)');
title('Feature Size Distribution');

true_total = sum_interest*(voxel_size^3)./1000./1000./1000
vol_total = sum(Rrs_vol_accum(:))
Rrs_vol_fract = Rrs_vol_accum./vol_total.*100;
figure;
plot(rs_array_nm, Rrs_vol_fract)  %need to be outputted
xlabel('Feature Diameter (nm)');
ylabel('Normalized Histogram Volume fraction (%)');
title('Feature Size Distribution');

check = sum(Rrs_vol_fract(:))
vol_total 
sum_interest*(voxel_size^3)./1000./1000./1000

rs_step = rs_array_nm(2)-rs_array_nm(1)

Rrs_vol_fract_norm = Rrs_vol_fract./rs_step
Rrs_vol_fract_norm(1) = Rrs_vol_fract(1)/(voxel_size*2)

%output to an excel spread sheet
xlswrite( excelfile, {['data input:',inpath, prefix]}, sheet_name, 'A1')
xlswrite( excelfile, {'data size:'}, sheet_name, 'A2')
xyz = size(img)
xlswrite( excelfile, xyz, sheet_name, 'B2:D2')

xlswrite( excelfile, {'feature size distribution'}, sheet_name, 'A4')
fieldname = {'feature diameter (nm)';'volume (µm3)'; 'Normalized Histogram Volume Fraction(%)'; 'Normalized Histogram Volume Fraction Probability Density (%/nm)'}
zeroscolumn = {'0';'0';'0';'0'} 
xlswrite( excelfile, fieldname', sheet_name, 'B5')
xlswrite(  excelfile, zeroscolumn', sheet_name, 'B6')
xlswrite( excelfile, rs_array_nm', sheet_name, 'B7')
xlswrite( excelfile, Rrs_vol_accum', sheet_name, 'C7')
xlswrite( excelfile, Rrs_vol_fract', sheet_name, 'D7')
xlswrite( excelfile, Rrs_vol_fract_norm', sheet_name, 'E7')

%output to a text file

fileID = fopen(textfile,'w');
%fprintf(fileID,'%6s %12s\n','x','exp(x)');
fprintf(fileID,'%s %s %s %s\n','feature_diameter_(nm)','volume_(µm3)','Normalized_Histogram_Volume_Fraction(%)','Normalized_Histogram_Volume_Fraction_Probability_Density(%/nm)');
fprintf(fileID,'%f %f %f %f\n',0.0, 0.0,0.0,0.0);

for i=1:size(rs_array,2)
fprintf(fileID,'%f %f %f %f\n',rs_array_nm(i), Rrs_vol_accum(i),Rrs_vol_fract(i),Rrs_vol_fract_norm(i));
end

fclose(fileID);


end