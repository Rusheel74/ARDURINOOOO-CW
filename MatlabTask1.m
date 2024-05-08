% Creates an Arduino varable to be used
a = arduino('COM3','UNO');
% Connect the temperature sensor to an analog pin
sensorPin = 'A0'; % Analog pin connected to the temperature sensor
%Variables
duration = 600; % Acquisition time in seconds
TC = 0.01; % Temperature coefficient
V0 = 0.5; % Zero-degree voltage
time=1:duration;
duration_mins = 10;
inititaltime = 0;
% Initialize arrays for acquired data
temperature = zeros(1,duration);
for i=1:duration
    voltage(i)=readVoltage(a,sensorPin);
    temperature(i)=(voltage(i)-V0)/TC;
    temp = sprintf('Temp: %0.2f°C', temperature(i)); 
    disp(temp);
    pause(1); 
end
% Calculate statistical quantities
minimumTemp = min(temperature);
maximumTemp = max(temperature);
averageTemp = mean(temperature);
%Plot a graph of temperature against time
plot(time,temperature)
xlabel('Time(s)');
ylabel('Temperature(°C)');
title('Temperature vs Time');
disp('');
% Initiation of data logging
disp('Data logging initiated - 10/04/2024');
disp('Location-Nottingham');
% Temperature at 0 Minutes
Timestr = sprintf('Minute/t/t0');
Tempstr = sprintf('Temperature/t%.2f°C', temperature(1));
disp(Timestr);
disp(Tempstr);
disp('');
% Temperature for each minute up until end of duration.
for i = 1:duration_mins
    mins_index = round(i*60)+1; % Adjusts so that the code will start from the 1st minute. 
    Timestr= sprintf('Minute/t/t%d',i); 
    if i == duration_mins
        Tempstr = sprintf('Temperature/t%.2f°C', temperature(end));
    else
        Tempstr = sprintf('Temperature/t%.2f°C', mins_index);
    end
    disp(Timestr);
    disp(Tempstr);
    disp('');
end
% Display the statistical quantities
disp(['Minimum Temperature ' char(9) num2str(minimumTemp) '°C']);
disp(['Maximum Temperature ' char(9) num2str(maximumTemp) '°C']);
disp(['Average Temperature ' char(9) num2str(averageTemp) '°C']);
disp('');
% Data logging termination
disp(['Data logging terminated'])
clear a;
% Writing permissions for data to the file
file_ID= fopen('cabin_temperature.txt','w');
fprintf(file_ID, 'Data logging initiated - 10/04/2024/n');
fprintf(file_ID,'Location-Nottingham/n/n')
% Temperature data display for each minute
for i = 0:duration_mins
    if i == 0
        Timestr = sprintf('Minute      /t/t0');
        Tempstr = sprintf('Temperature /t%.2f°C ', temperature(1)); 
    else
        mins_index = round(i*60)+1;
        Timestr = sprintf('Minute      /t/t0');
        if i == duration_mins
            Tempstr = sprintf('Temperature   /t%.2f°C', temperature(end)); 
        else
            Tempstr = sprintf('Temperature   /t%.2f°C', temp(mins_index));
        end
    end
        fprintf(file_ID, '%s/n', Timestr);
        fprintf(file_ID, '%s/n', Tempstr);
        fprintf(file_ID, '/n');
end
% Display the statistical quantities
fprintf(file_ID, 'Maximum Temperature       /t%.2f°C/n', maximumTemp);
frpintf(file_ID, 'Minumum Temperature       /t%.2f°C/n', minimumTemp);
frpintf(file_ID, 'Average Temperature       /t%.2f°C/n', averageTemp);
% Data logging being terminated
frpintf(file_ID, '/n Data logging terminated/n');
% Closing the file down
flcose(file_ID);

%Reopening this file
file_ID = fopen('cabin_temperature.txt','r'); % r so that you can read the text file.
if file_ID == -1
    disp(' Error: Unable to open the file');
else
    disp('File has reopened succesfully');
    fclose(file_ID); % Ensure that the file is closed after being used
end
clear a






