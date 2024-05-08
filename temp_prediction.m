function temp_prediction
    a = ardurino('COM3','UNO');% Creates the Arduino variable and establishes aconnection
      % Constants for temperature conversion
    V0 = 0.5; % Vzero value
    Tc = 0.01; % Tc value
    
    % Initializing variables
    time = 0; 
    temp_pre = 0; % Previous temperature for rate calculation
    rate_tc = 0; % Initial temperature change rate
    
    % Threshold for temperature change rate (in °C/s) Converting from mins
    % to secs.
    maxChangeRate = 4/60; % °C/s
    % Initialize LED pins
    greenLED = 'D2';
    yellowLED = 'D3';
    redLED = 'D4';
    configurePin(a, greenLED, 'DigitalOutput');
    configurePin(a, yellowLED, 'DigitalOutput');
    configurePin(a, redLED, 'DigitalOutput');

    % Main loop
    while true
        % Reads the  temperature from thermistor
        A0_voltage = readVoltage(a, 'A0');
        temp_n = (A0_voltage - V0) / Tc; % Convers the voltage to temperature
        
        % Calculate temperature change rate
        if time > 0
            d_time = 60; % Data span in seconds
            temp_change = temp_n - temp_pre;
            rate_tc = temp_change / d_time; % °C/s
        end
        
        % Print temperature data
        fprintf('\nRate of Temperature Change: %.2f °C/s\n', rate_tc); % Output of the temperature change rate
        fprintf('Current Temperature: %.2f °C\n', temp_n); % Output of the current temperature
        fprintf('Temperature Expected in 5 Minutes: %.2f °C\n', temp_n + rate_tc * 300); %Output of temperature prediction in 5 mins.
        
        % Control LEDs based on temperature stability and rate of change
        if abs(rate_tc) <= maxChangeRate
            writeDigitalPin(a, greenLED, 1); % Turn on green LED
            writeDigitalPin(a, yellowLED, 0); % Turn off yellow LED
            writeDigitalPin(a, redLED, 0); % Turn off red LED
        elseif rate_tc > maxChangeRate
            writeDigitalPin(a, greenLED, 0); % Turn off green LED
            writeDigitalPin(a, yellowLED, 0); % Turn off yellow LED
            writeDigitalPin(a, redLED, 1); % Turn on red LED
        elseif rate_tc < -maxChangeRate
            writeDigitalPin(a, greenLED, 0); % Turn off green LED
            writeDigitalPin(a, yellowLED, 1); % Turn on yellow LED
            writeDigitalPin(a, redLED, 0); % Turn off red LED
        end
        
        % Update variables
        temp_pre = temp_n;
        time = time + 1;
        
        pause(1); % Pause for interval between temperature readings
    end
end

% Monitors the temperature from the sensor and calculates the rate of
% temperatue change. LED lights are controlled based on the temperature
% stavility as well as its rate of change. It helos find the current
% temperature and temperature expected in 5 minutes assuming it is at a
% constant rate of cgange. A Green LED light is displayed if its within the
% range, a yellow LED light means that the temperature is decreasing and a
% red LED light indicates that the temperature variation has gone above
% the range.
