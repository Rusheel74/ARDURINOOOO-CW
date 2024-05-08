% Rusheel Gupta
% egyrg3@nottingham.ac.uk

%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]
% Specifyingt the port and Arduino to be used.
port = 'COM3'; % The port that the Ardurino is connected to.
arduinoType = 'Uno'; % The type of Ardurino to be implemented

% Creating a variable assigning the Ardurino
a = arduino(port, arduinoType);

% Connecting the LED to a digital pin
ledPin = 'D13'; % Thye pin that connects the LED to the Ardurino
configurePin(a, ledPin, 'DigitalOutput');

% Turning on the LED
writeDigitalPin(a, ledPin, 1); % Appling 5V to the LED to light it up.
pause(1); % Waits for 1 second

% Turning off the LED
writeDigitalPin(a, ledPin, 0); % Applying 0V to the LED to turn it off.
pause(1); % Waits for 1 second

% Loop to make the LED blink
numBlinks = 10; % Number of times the LED needs to blink
interval = 0.5; % Time intervals for the blinks in the LED.

% Loop to blink the LED
for i = 1:numBlinks
    % Turns on the LED
    writeDigitalPin(a, ledPin, 1); % Applying  5V to the LED to light it up.
    pause(interval); % Wait for the specified interval
    
    % Turn off the LED
    writeDigitalPin(a, ledPin, 0); % Applying 0V to the LED to turn it off
    pause(interval); % Wait for the specified interval
end

% Clears the Arduino object
clear a;


%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
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



%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
function temp_monitor(a)

%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]
function temp_prediction(a)

%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% This project helped to take a oppertuniy to go into the world of harware
% integration, and real-world application of theoretical concepts. From the
% start, challenges had emerged, in understanding the Arduino-MATLAB
% communication and calibrating the temperature senser to ensure the
% readings are accurate. Integrating the Ardurino board to MATLAB had some
% troubleshooting connecivity issues which demanded patience and belief.
% Also, while calibrating the temperature sensor was a challenge as it gave
% voltage readings and ensuring precise conversions into temperatures.
% These challenges required theoretical knowledge and problem solving
% skills to overcome. Despite these challenges, there were strengths in the
% project. MATLAB offers flexibility allowing complex algorithms and data
% processing techniques required to monitor the temperature and control the
% LED. Having clear and consise code and documentation strenghtens the
% process, ensuring that the code being written is easy to
% understand.However, the project also has its own limitations. It is
% heavily reliant on components such as the Ardurino board and the
% temperature sensor limiting it to setups with a similar configuration.
% The simplified prediction model also assumed that there was a constant
% rate of change which won't reflect well in real-world scenarios. Further
% improvements on this project would be to know how to use Ardurino better
% and possibly some of the code couldve been more clear and concise.
% Finding a way to ensure the temperature sensor produces accurate readings
% and applying my skills better in the future.

