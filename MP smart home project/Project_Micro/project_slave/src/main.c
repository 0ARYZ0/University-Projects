#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <avr/io.h>
#include <util/delay.h>
#include <LCD.h>
#include <avr/interrupt.h>


char password[] = "123";
char Is_pass_correct = 0;
char lightORtemp = 0;
char key_pressed = 0;
double cooler_DS = 0;
double heater_DS = 0;
double light_DS = 0;

// our 8 bit key for encryption
char encrypt_key = 0b10000001;
//char encrypt_key = 0b10000000;  if you use this key instead of the above 
                                // you can see that our encrytion work and if you enter 
                           //     the password it show that it is another password
//

void init_OCR(){
    
    // PD4 and PD5 pins are output
    DDRD |= (1 << PD4) | (1 << PD5);
    PORTD &= ~((1 << PD4) | (1 << PD5));
    //OC1A and OC1B output
    // Set Timer1 to Fast PWM mode, non-inverted output
    TCCR1A |= (1 << COM1A1) | (1 << COM1B1) | (1 << WGM10);
    TCCR1B |= (1 << WGM12) | (1 << CS11);
    // Set PWM pins as non-inverted
    TCCR1A &= ~(1 << COM1A0);
    TCCR1A &= ~(1 << COM1B0);
}

void init_light_motor() {
    DDRD |= (1 << PORTD7);     // DDRD &= 0x7F;
    TCCR2 = 0x00;
    TCCR2 |= (1 << WGM21) | (1 << WGM20);         // fast pwm
    TCCR2 |= (1 << COM21);         // clear Oc0 on compare match
    TCCR2 |= (1 << CS21);           // 1/8 clock prescaling
    OCR2 = (light_DS / 100) * 255;
    //i=ADC/204.8;
    //LDR = (i*10/(5-i));
}

int main(void){
    
    //for int2(telling master that password is correct)
    DDRB |= (1 << PB3);
    PORTB &= ~(1 << PB3);
    // (SCK/DDB7 = 0)      Clock
    // (MISO/DDB6 = 1)      Master in slave out
    // (MOSI/DDB5 = 0)     Master out slave in
    // (SS/DDB4 = 0)     Being slave 
    //SPI signals
    DDRB = (0 << PB4) | (0 << PB5) | (1 << PB6) | (0 << PB7);
    // (SPE = 1)     Enable SPI
    // (DORD = 0)     SPI data order: MSB First
    // (MSTR = 0)     SPI type: Slave
    // (CPOL = 1)    SPI clock polarity: high
    // SPIE    spi interupt enable
    SPCR = (1 << SPE) | (0 << MSTR) |(1 << SPIE) | (0 << DORD) |(1 << CPOL);

    //lcd data
    DDRA = 0xFF;
    DDRB |= (1 << PB0) | (1 << PB1) | (1 << PB2);
    init_LCD();

    // select LEDs , and buzzers
    DDRC = (1 << DDC1) | (1 << DDC2) |(1 << DDC3) | (1 << DDC4);

    init_OCR();
    init_light_motor();
    sei();
    while(1){
    }
}

void temp_cond(int temperature){
    if(temperature > 55){
        // select LEDs
        heater_DS = 0.0;
        cooler_DS = 0.0;
        
        PORTC &= ~(1 << PORTC2);
        PORTC ^= (1 << PORTC1);
        //for buzzer
        PORTC |= (1 << PORTC3) ;
        PORTC &= ~(1 << PORTC4);
    }else if(temperature < 3){
        // select LEDs 
        heater_DS = 0.0;
        cooler_DS = 0.0;
        //for buzer
        PORTC &= ~(1 << PORTC3) ;
        PORTC |= (1 << PORTC4);

        PORTC &= ~(1 << PORTC1);
        PORTC ^= (1 << PORTC2);
    }else if(3 <= temperature && temperature <= 55){
        PORTC &= ~(1 << PORTC3);
        PORTC &= ~(1 << PORTC4);
        PORTC &= ~(1 << PORTC2);
        PORTC &= ~(1 << PORTC1);
        if(3 <= temperature && temperature <= 5){
            cooler_DS = 0.0;
            heater_DS = 100.0;
        }else if(6 <= temperature && temperature <= 10){
            cooler_DS = 0.0;
            heater_DS = 75.0;
        }else if(11 <= temperature && temperature <= 15){
            cooler_DS = 0.0;
            heater_DS = 50.0;
        }else if(16 <= temperature && temperature <= 20){
            cooler_DS = 0.0;
            heater_DS = 25.0;
        }else if(26 <= temperature && temperature <= 30){
            cooler_DS = 50.0;
            heater_DS = 0.0;
        }else if(31 <= temperature && temperature <= 35){
            cooler_DS = 60.0;
            heater_DS = 0.0;
        }else if(36 <= temperature && temperature <= 40){
            cooler_DS = 70.0;
            heater_DS = 0.0;
        }else if(41 <= temperature && temperature <= 45){
            cooler_DS = 80.0;
            heater_DS = 0.0;
        }else if(46 <= temperature && temperature <= 50){
            cooler_DS = 90.0;
            heater_DS = 0.0;
        }else if(51 <= temperature && temperature <= 55){
            cooler_DS = 100.0;
            heater_DS = 0.0;
        }
        else{ //between 20 and 25
        heater_DS = 0.0;
        cooler_DS = 0.0;
        }
    }
    // x = x / 100 * 255
    OCR1A = cooler_DS * 2.55;
    OCR1B = heater_DS * 2.55;
}

void light_cond(int light){
    if(0 <= light && light < 25){
        light_DS = 100;
    }else if(25 <= light && light < 50){
        light_DS = 75;
    }else if(50 <= light && light < 75){
        light_DS = 50;
    }else if(75 <= light && light < 100){
        light_DS = 25;
    }
    OCR2 = (light_DS / 100) * 255;

}

void lcd_string_write(char s[]){
    int i = 0;
    while (s[i] != '\0')
    {
        LCD_write(s[i]);
        i++;
    }
}


void access(){
    DDRB |= (1 << PB3);
    PORTB &= ~(1 << PB3);
}


char enterd_password[8];
int current_index = 0;
char hideORshow = 0;
ISR(SPI_STC_vect){
    key_pressed = SPDR;
    key_pressed = key_pressed ^ encrypt_key; // for decryption of data
    if(!Is_pass_correct){
        if(key_pressed == '*'){
            if(strcmp(password, enterd_password) == 0){
                Is_pass_correct = 1;
                access();
                LCD_cmd(0x01);  //clear LCD
                lcd_string_write("Welcome!");
            }else{
                LCD_cmd(0x01);  
                lcd_string_write("Wrong password");
                current_index = 0;
                enterd_password[current_index] = '\0';
                _delay_ms(1000);
                LCD_cmd(0x01);  
            }
        }
        else if(key_pressed == '#'){
            current_index--;
            enterd_password[current_index] = '\0';
            LCD_cmd(0x10);     //shift cursor to the left
            LCD_write(' ');
            LCD_cmd(0x10);     //shift cursor to the left
        }
        else if((key_pressed ^ encrypt_key) == 'P'){
            LCD_cmd(0x01);     
            hideORshow ^= 1;
            if(hideORshow){
                lcd_string_write(enterd_password);
            }else{
                for(int j = 0; j < current_index; j++){
                    LCD_write('*');
                }
            }
        }else{     //key is a part of the password 
            enterd_password[current_index] = key_pressed;
            current_index++;
            enterd_password[current_index] = '\0';
            if(hideORshow){
                LCD_write(key_pressed);
            }else{
                LCD_write('*'); 
            }
        }
    }else{      //you enetered the correct password ,starting the OCR
        if(lightORtemp){       //for temperature
            lightORtemp ^= 1;
            temp_cond(key_pressed);
        }else{
            lightORtemp ^= 1;  //for light
            light_cond(key_pressed);

        }
    }
}



























































