a = arduino(); % Creates the Arduino variable and establishes aconnection
 % Connect the LEDs to the corresponding pins
    greenPin = 'D2'; % Green LED connected to digital pin D2
    yellowPin = 'D3'; % Yellow LED connected to digital pin D3
    redPin = 'D4'; % Red LED connected to digital pin D4
    
    % Initialize the LEDs as outputs
    configurePin(a, greenPin, 'DigitalOutput');
    configurePin(a, yellowPin, 'DigitalOutput');
    configurePin(a, redPin, 'DigitalOutput');
    
    % Initialize variables for temperature monitoring
    duration = 600; % Acquisition time in seconds
    temperature = zeros(1, duration);
    time = 1:duration;
    
    % Define the temperature coefficient and reference voltage
    tc = 0.01; % Temperature coefficient in V/°C
    v0 = 0.5; % Reference voltage at 0 degrees Celsius
    
    % Initialize the live graph
    figure;
    h = plot(time, temperature);
    xlabel('Time (s)');
    ylabel('Temperature (°C)');
    title('Temperature vs Time');
    xlim([1, duration]); % Set the x-axis limits
    ylim([-10, 40]); % Set the y-axis limits
    
    % Enter an infinite loop for temperature monitoring and LED control
    while true
        % Read the temperature from the sensor
        voltage = readVoltage(a, 'A0');
        temperature(end) = (voltage - v0) / tc; % Calculate the current temperature
        
        % Update the live graph
        set(h, 'YData', temperature);
        drawnow;
        
        % Control the LEDs based on the temperature
        if temperature(end) >= 18 && temperature(end) <= 24
            % Temperature within the range 18-24 °C, turn on the green LED
            writeDigitalPin(a, greenPin, 1); % Turn on the green LED
            writeDigitalPin(a, yellowPin, 0); % Turn off the yellow LED
            writeDigitalPin(a, redPin, 0); % Turn off the red LED
        elseif temperature(end) < 18
            % Temperature below 18 °C, blink the yellow LED
            writeDigitalPin(a, greenPin, 0); % Turn off the green LED
            
            % Blink the yellow LED at intervals of 0.5 seconds
            for i = 1:duration
                writeDigitalPin(a, yellowPin, 1); % Turn on the yellow LED
                pause(0.5); % Keep the LED on for 0.5 seconds
                writeDigitalPin(a, yellowPin, 0); % Turn off the yellow LED
                pause(0.5); % Keep the LED off for 0.5 seconds
            end
            
            writeDigitalPin(a, redPin, 0); % Turn off the red LED
        else
            % Temperature above 24 °C, blink the red LED
            writeDigitalPin(a, greenPin, 0); % Turn off the green LED
            
            % Blink the red LED at intervals of 0.25 seconds
            for i = 1:duration
                writeDigitalPin(a, redPin, 1); % Turn on the red LED
                pause(0.25); % Keep the LED on for 0.25 seconds
                writeDigitalPin(a, redPin, 0); % Turn off the red LED
                pause(0.25); % Keep the LED off for 0.25 seconds
            end
            
            writeDigitalPin(a, yellowPin, 0); % Turn off the yellow LED
        end
        
        % Wait for approximately 1 second before the next iteration
        pause(1);
    end