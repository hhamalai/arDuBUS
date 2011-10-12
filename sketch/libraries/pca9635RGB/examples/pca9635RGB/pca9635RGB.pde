/**
 * Remember your I2C pull-up resistors
 */
#include <Wire.h> // For some weird reason including this in the relevant .h file does not work
// For the weirdest reason this does not get to the scope of the libraries
#define I2C_DEVICE_DEBUG
#include <i2c_device.h> // For some weird reason including this in the relevant .h file does not work
#include <pca9635.h> // For some weird reason including this in the relevant .h file does not work
#include <pca9635RGB.h>

// Container for the device
pca9635RGB driverboard;

void setup()
{
    Serial.begin(115200);
    // Set device address and call Wire.begin() (note: fake addesss)
    driverboard.begin(8);
    driverboard.R.dump_registers(0x0, 0x1);
    driverboard.G.dump_registers(0x0, 0x1);
    driverboard.B.dump_registers(0x0, 0x1);
    delay(1);
    driverboard.R.reset();
    delay(1);
    driverboard.R.dump_registers(0x0, 0x1);
    driverboard.G.dump_registers(0x0, 0x1);
    driverboard.B.dump_registers(0x0, 0x1);
    delay(1);
    driverboard.R.set_driver_mode(0);
    driverboard.G.set_driver_mode(0);
    driverboard.B.set_driver_mode(0);
    delay(1);
    driverboard.R.dump_registers(0x0, 0x1);
    driverboard.G.dump_registers(0x0, 0x1);
    driverboard.B.dump_registers(0x0, 0x1);
    // Fully enable all led PWMs
    for (byte reg=0x14; reg<=0x17; reg++)
    {
        driverboard.R.write(reg, 0xFF);
        driverboard.G.write(reg, 0xFF);
        driverboard.B.write(reg, 0xFF);
    }
    for (byte i=0; i<9; i++)
    {
        Serial.print("_BV(");
        Serial.print(i, DEC);
        Serial.print(")=B");
        Serial.println(_BV(i), BIN);
        Serial.print("~_BV(");
        Serial.print(i, DEC);
        Serial.print(")=B");
        Serial.println((byte)~_BV(i), BIN);
    }
    
    Serial.println("Booted");
}

void loop()
{
    for (byte ledno = 0; ledno < 16; ledno++)
    {
        Serial.print("Turning on R led ");
        Serial.println(ledno, DEC);
        //driverboard.R.set_led_mode(ledno, 1);
        driverboard.R.set_led_pwm(ledno, 255);
        delay(750);
        Serial.print("Turning off R led ");
        Serial.println(ledno, DEC);
        driverboard.R.set_led_pwm(ledno, 0);
        //driverboard.R.set_led_mode(ledno, 0);
        Serial.print("Turning on G led ");
        Serial.println(ledno, DEC);
        //driverboard.G.set_led_mode(ledno, 1);
        driverboard.G.set_led_pwm(ledno, 255);
        delay(750);
        Serial.print("Turning off G led ");
        Serial.println(ledno, DEC);
        driverboard.G.set_led_pwm(ledno, 0);
        //driverboard.G.set_led_mode(ledno, 0);
        Serial.print("Turning on B led ");
        Serial.println(ledno, DEC);
        //driverboard.B.set_led_mode(ledno, 1);
        driverboard.B.set_led_pwm(ledno, 255);
        delay(750);
        Serial.print("Turning off B led ");
        Serial.println(ledno, DEC);
        driverboard.B.set_led_pwm(ledno, 0);
        //driverboard.B.set_led_mode(ledno, 0);
    }
    // Dump device registers and wait 15sek
    Serial.println("Calling driverboard.R.dump_registers(0x0, 0x1b)");
    driverboard.R.dump_registers(0x0, 0x1b);
    Serial.println("Calling driverboard.G.dump_registers(0x0, 0x1b)");
    driverboard.G.dump_registers(0x0, 0x1b);
    Serial.println("Calling driverboard.B.dump_registers(0x0, 0x1b)");
    driverboard.B.dump_registers(0x0, 0x1b);
    delay(15000);
}
