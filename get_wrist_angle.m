clc; clear all; close all;

% open data files
imu = readtable('imu.csv');
img_file = readtable('IMG_2 (Instance).csv');
falcon_file = readtable('novint-falcon.csv');

% find trial start times
img_start_time = img_file.time_s_(1);
falcon_start_time = char(falcon_file.globalTime(find(falcon_file.time_s_==img_start_time)));
imu_start_ind = find(extractBetween(string(imu.Time), 3, 8)==falcon_start_time(3:8),1,'first');

% find trial end times
falcon_end_time = char(falcon_file.globalTime(end));
imu_end_ind = find(extractBetween(string(imu.Time), 3, 8)==falcon_end_time(3:8),1,'first');

% remove drift from yaw in IMU1
x1 = 1:(imu_end_ind-imu_start_ind+1); 
y1 = imu.Yaw1(imu_start_ind:imu_end_ind); 
P1 = polyfit(x1,y1,1);
m = P1(1); % slope
n = P1(2); % intercept
n0 = n-m*imu_start_ind; % intercept starting from the beginning of time series (not trial)
yfit1 = n0+m*[1:length(imu.Yaw1)];
cleaned_yaw1 = imu.Yaw1 - yfit1';

% figure
% hold on
% plot(1:length(imu.Yaw1),imu.Yaw1)
% plot(imu_start_ind:imu_end_ind,imu.Yaw1(imu_start_ind:imu_end_ind))
% plot(1:length(yfit1),yfit1)
% plot(1:length(cleaned_yaw1),cleaned_yaw1)
% hold off


% remove drift from yaw in IMU2
x2 = 1:(imu_end_ind-imu_start_ind+1); 
y2 = imu.Yaw2(imu_start_ind:imu_end_ind); 
P2 = polyfit(x2,y2,1);
m = P2(1); % slope
n = P2(2); % intercept
n0 = n-m*imu_start_ind; % intercept starting from the beginning of time series (not trial)
yfit2 = n0+m*[1:length(imu.Yaw2)];
cleaned_yaw2 = imu.Yaw2 - yfit2';

% figure
% hold on
% plot(1:length(imu.Yaw2),imu.Yaw2)
% plot(imu_start_ind:imu_end_ind,imu.Yaw2(imu_start_ind:imu_end_ind))
% plot(1:length(yfit2),yfit2)
% plot(1:length(cleaned_yaw2),cleaned_yaw2)
% hold off


% Extract yaw, pitch, and roll for IMU1
roll1 = imu.Roll1; 
pitch1 = imu.Pitch1; 
yaw1 = imu.Yaw1;
 
% Extract yaw, pitch, and roll for IMU2
roll2 = imu.Roll2; 
pitch2 = imu.Pitch2; 
yaw2 = imu.Yaw2;

% Calculate quaternions for both IMUs
q1 = quaternion([roll1, pitch1, cleaned_yaw1], 'eulerd', 'XYZ', 'frame');
q2 = quaternion([roll2, pitch2, cleaned_yaw2], 'eulerd', 'XYZ', 'frame');

% Calculate the relative orientation (wrist angles)
q_relative = conj(q1) .* q2;

% Extract Euler angles from the relative orientation
eulerAngles = eulerd(q_relative, 'XYZ', 'frame');

% Convert the matrix to a table
eulerAnglesTable = array2table(eulerAngles, 'VariableNames', {'Roll', 'Pitch', 'Yaw'});

% Add the "Time" column to the table
eulerAnglesTable.Time = imu.Time;

% Reorder the columns so that "Time" is the first column
eulerAnglesTable = eulerAnglesTable(:, {'Time', 'Roll', 'Pitch', 'Yaw'});

% figure;
% subplot(3,1,1); plot(eulerAngles(:,1)); title('Roll (Wrist)');
% subplot(3,1,2); plot(eulerAngles(:,2)); title('Pitch (Wrist)');
% subplot(3,1,3); plot(eulerAngles(:,3)); title('Yaw (Wrist)');

writetable(eulerAnglesTable,['wrist-angles.csv'], 'WriteRowNames', false);
