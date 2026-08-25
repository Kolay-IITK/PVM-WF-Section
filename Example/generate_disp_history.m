% ==============================================================================
% MATLAB Script: Generate Displacement History Data for OpenSees
% Output: disp_history.dat (Saved in the SAME folder as this MATLAB script)
% ==============================================================================
clc; clear; close all;

% Get the directory where this script resides
[script_dir, ~, ~] = fileparts(mfilename('fullpath'));

% 1. Read Raw Link Angle/Rotation Data from the script folder
raw_file = fullfile(script_dir, 'ebf-shear-link-angle-18'); 
if ~file_exist(raw_file) && file_exist([raw_file, '.csv'])
    raw_file = [raw_file, '.csv'];
end

t_org = readmatrix(raw_file);

% 2. Interpolation / Upsampling Setup
x = (1:length(t_org))';
factor = 1; % Upsampling factor
x_fine = linspace(1, length(t_org), length(t_org)*factor)';

t(:,1) = interp1(x, t_org(:,1), x_fine, 'spline');
t(:,2) = interp1(x, t_org(:,2), x_fine, 'spline');

% Linear correction over target region
i1 = 1233; i2 = 1249;
if length(t(:,1)) >= i2
    t(i1:i2,2) = linspace(t(i1,2), t(i2,2), i2 - i1 + 1);
    t(i1:i2,1) = linspace(t(i1,1), t(i2,1), i2 - i1 + 1);
end

% 3. Calculate Shear Displacement (mm)
L_link = 711.2; % Link length in mm
shear_def = t(:,1) * L_link;

% 4. Export Single-Column Data File in the SAME folder
output_filepath = fullfile(script_dir, 'disp_history.dat');
fileID = fopen(output_filepath, 'w+');

if fileID == -1
    error('Could not create output file at: %s', output_filepath);
end

for i = 1:length(shear_def)
    fprintf(fileID, '%.8f\r\n', shear_def(i));
end

fclose(fileID);
fprintf('Successfully generated displacement data file: %s\n', output_filepath);

function exists = file_exist(fname)
    exists = (exist(fname, 'file') == 2);
end