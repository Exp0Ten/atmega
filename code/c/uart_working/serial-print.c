#include <avr/io.h>
#define F_CPU 16000000UL
#include <util/delay.h>


#define DOUBLE_SPEED 1
#define BAUD 9600


#if DOUBLE_SPEED 
	#define UBRR_VALUE ((F_CPU / (8UL * BAUD)) - 1)
#else
	#define UBRR_VALUE ((F_CPU / (16UL * BAUD)) - 1)
#endif

void uart_init() {
#if DOUBLE_SPEED
	UCSR0A |= (1 << U2X0); // Enable double-speed mode
#else
	UCSR0A &= ~(1 << U2X0); // Clear U2X0 for standard speed mode
#endif

    UBRR0H = (UBRR_VALUE >> 8);
    UBRR0L = UBRR_VALUE;
    UCSR0B = (1 << TXEN0); // Enable transmitter
    UCSR0C = (1 << UCSZ01) | (1 << UCSZ00); // 8N1
}

void uart_transmit(char data) {
    while (!(UCSR0A & (1 << UDRE0)));
    UDR0 = data;
}

int main() {
    uart_init();
    while (1) {
        uart_transmit('A'); // Send 'A'
        _delay_ms(500);
    }
    return 0;
}
