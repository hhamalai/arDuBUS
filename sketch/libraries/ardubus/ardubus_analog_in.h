#ifndef ardubus_analog_in_h
#define ardubus_analog_in_h
#include <WProgram.h> 
#ifndef ARDUBUS_ANALOG_IN_UPDATE_TIME
#define ARDUBUS_ANALOG_IN_UPDATE_TIME 5 // Milliseconds, how often to check if inputs have changed
#endif


const byte ardubus_analog_in_pins[] = ARDUBUS_ANALOG_INPUTS; // Analog inputs, unfiltered
int ardubus_analog_in_lastvals[sizeof(ardubus_analog_in_pins)]; // Store last value so we have at least the most rudimentary form of filtering for changes

inline void ardubus_analog_in_setup()
{
    for (byte i=0; i < sizeof(ardubus_analog_in_pins); i++)
    {
        pinMode(ardubus_analog_in_pins[i], INPUT);
        digitalWrite(ardubus_analog_in_pins[i], LOW); // Make sure the internal pull-up is disabled
        ardubus_analog_in_lastvals[i] = analogRead(ardubus_analog_in_pins[i]);
    }
}

unsigned long ardubus_digital_in_last_read_time;
inline void ardubus_analog_in_read_inputs()
{
    for (byte i=0; i < sizeof(ardubus_analog_in_pins); i++)
    {
        int tmp = analogRead(ardubus_analog_in_pins[i]);
        if (tmp != ardubus_analog_in_lastvals[i])
        {
            ardubus_analog_in_lastvals[i] = tmp;
            Serial.print("CA"); // CA<pin_byte><value in hex>
            // PONDER: Use index instead of pin-number ?
            Serial.print(ardubus_analog_in_pins[i]);
            // This might not be the best way to pass this info, maybe fixed-lenght encoding would be better ?
            Serial.println(ardubus_analog_in_lastvals[i], HEX);
        }
    }
    ardubus_digital_in_last_read_time = millis();
}

inline void ardubus_analog_in_update()
{
    if ((millis() - ardubus_digital_in_last_read_time) > ARDUBUS_ANALOG_IN_UPDATE_TIME)
    {
        ardubus_analog_in_read_inputs();
    }
}

inline void ardubus_analog_in_report()
{
    for (byte i=0; i < sizeof(ardubus_analog_in_pins); i++)
    {
        Serial.print("RA"); // CA<pin_byte><value in hex>
        // PONDER: Use index instead of pin-number ?
        Serial.print(ardubus_analog_in_pins[i]);
        // This might not be the best way to pass this info, maybe fixed-lenght encoding would be better ?
        Serial.println(ardubus_analog_in_lastvals[i], HEX);
        // TODO: Add duration info
    }
}

inline void ardubus_analog_in_process_command(char *incoming_command)
{
    // This is a no-op (but defined so that all submodules have same API)
}


#endif
// *********** END OF CODE **********
