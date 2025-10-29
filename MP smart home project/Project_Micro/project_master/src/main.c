#include <avr/io.h>
#include <util/delay.h>
#include <LCD.h>
#include <avr/interrupt.h>

char keyFind();
void Enable_sensors();
void send_SPI_data(char data);
int Read_temp();
int read_light();

// our 8 bit key for encryption
char encrypt_key = 0b10000001;
//

char sensors_enable = 0;
char Is_pass_correct = 0;

int main(void){
    // (SCK/DDB7 = 1)    Send clock
    // (MISO/DDB6 = 0)  Master in slave out
    // (MOSI/DDB5 = 1)   Master out slave in
    // (SS/DDB4 = 1)     Slave select
    DDRB = (1 << PB4) | (1 << PB5) | (0 << PB6) | (1 << PB7);
    PORTB |= (1 << PB4);
    // (SPE = 1)     Enable SPI
    // (DORD = 0)     SPI data order: MSB First
    // (MSTR = 1)    SPI type: Master
    // (CPOL = 1)    SPI clock polarity: high
    SPCR = (1 << SPE) | (1 << MSTR) | (0 << DORD) |(1 << CPOL);
    SPCR &= ~((1 << SPR0) | (1 << SPR1));
    SPSR &= ~(1 << SPI2X);
    _delay_ms(10);
    //this is for noise similar to pullup
    PIND |= (1 << PIND2);
    //enable int0
    GICR |= (1 << INT0);
    //interupt on rising edge
    MCUCR |= (1 << ISC00) | (1 << ISC01);

    //for noise
    PINB |= (1 << PINB2);
    //enable int2
    GICR |= (1 << INT2);
    //interupt on falling edge
    MCUCSR &= ~(0 << ISC2);

    char key;
    int temprature;
    int light;
    sei();

    while (1){
        if(Is_pass_correct == 0){
            key = keyFind();
            if(Is_pass_correct == 0){
                send_SPI_data(key);
            }
        }else{
            if(sensors_enable){
                light = read_light();
                send_SPI_data(light);
                _delay_ms(500);
                temprature = Read_temp();
                _delay_ms(500);
                send_SPI_data(temprature);
            }else{
                Enable_sensors();
                sensors_enable = 1;
            }
            
        } 
    }
}


unsigned char keypad[4][4] = {	{'1','2','3'},
				                {'4','5','6'},
				                {'7','8','9',},
				                {'*','0','#'}};


                                



unsigned char col, row, t;
char keyFind(){
    while(1){
        //output rows, input columns
        DDRC = 0b01111000;
        do{
            PORTC = 0b00000111;
            t = (PINC & 0b00000111);   
        }while(t != 0b00000111);    // repeat until a button is pushed

        
        do{
            col = (PINC & 0b00000111);
        }while(col == 0b00000111);   // repeat until col is read

        //active(makging low) all rows one by one to see if the col is in that row
        PORTC = 0b01110111;                     
        col = (PINC & 0b00000111);
        if(col != 0b00000111){        //if col changes while row 0 is active then row 0 is choosed
            row = 0;
            break;
        }

        PORTC = 0b01101111;
        col = (PINC & 0b00000111);
        if(col != 0b00000111){
            row = 1;
            break;
        }

        PORTC = 0b01011111;
        col = (PINC & 0b00000111);
        if(col != 0b00000111){
            row = 2;
            break;
        }

        PORTC = 0b00111111;
        col = (PINC & 0b00000111);
        if(col != 0b00000111){
            row = 3;
            break;
        }
    }

    if(col == 0b00000110){
        return keypad[row][0];
    }
    else if(col == 0b00000101){
        return keypad[row][1];
    }
    else{
        return keypad[row][2];
    }
}


void Enable_sensors(){
    DDRA = 0;    //port A  input
    ADCSRA = (1 << ADEN) | (0 << ADSC) | (0 << ADATE) | (1 << ADPS1) | (1 << ADPS0) | (1 << ADPS2); //division factor = 8
    SFIOR &= ~((1 << ADTS2) | (1 << ADTS1) | (1 << ADTS0)); //free running mod
    ADMUX = (0 << REFS1) | (1 << REFS0);// we select voltage from pin avcc
}

char temp; //for clearing spsr only

void send_SPI_data(char data){
    PORTB &= ~(1 << PB4);//SS_enable
    data = data ^ encrypt_key; // for encryption
    SPDR = data;
    while(!(SPSR & (1 << SPIF)));
    temp = SPDR;    //clear spsr
    PORTB |= (1 << PB4); //SS_disable
}


int Read_temp(){
    ADMUX &= ~((1 << MUX4) | (1 << MUX3) | (1 << MUX2) | (1 << MUX1) | (1 << MUX0)); //select ADC0
    ADCSRA |= (1 << ADSC);   // start conversion   
    while((ADCSRA &(1 << ADIF)) == 0);// Wait till end of the conversion
    return ADCW * 0.488;// 1 volt of lm35 is equal to 100 degree Celcius
}

int read_light(){
    ADMUX &= ~((1 << MUX4) | (1 << MUX3) | (1 << MUX2) | (1 << MUX1) | (1 << MUX0));
    ADMUX |= (1 << MUX0); //select ADC1
    ADCSRA |= (1 << ADSC);      
    while((ADCSRA &(1 << ADIF)) == 0);
    return ADCW * 0.488;
    //i=ADC/204.8;
    //LDR = (i*10/(5-i));
}



ISR(INT0_vect){
    PORTB &= ~(1 << PB4); //SS_enable
    SPDR = 'P';
    while(!(SPSR & (1 << SPIF)));
    temp = SPDR; //clear spsr
    PORTB |= (1 << PB4); //SS_disable
}

ISR(INT2_vect){
    Is_pass_correct = 1;
}













