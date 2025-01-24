#define F_CPU 16000000UL
#define BAUD 9600
#define UBRR_VALUE ((F_CPU / (16UL * BAUD)) - 1)

#define TXEN0 3
#define UCSZ01 2
#define UCSZ00 1

#define UDRE0 5

void uart_init() {
	int * UBRR0H = (int *) 0xC5;
	int * UBRR0L = (int *) 0xC4;
	int * UCSR0A = (int *) 0xC0;
	int * UCSR0B = (int *) 0xC1;
	int * UCSR0C = (int *) 0xC2;

    *UCSR0A = 0; // disable 2 times speed
    *UBRR0H = (UBRR_VALUE >> 8);
    *UBRR0L = UBRR_VALUE;
    *UCSR0B = (1 << TXEN0); // Enable transmitter
    *UCSR0C = (1 << UCSZ01) | (1 << UCSZ00); // 8N1
}

void uart_transmit(char data) {
	int * UCSR0A = (int *) 0xC0;
	int * UDR0 = (int *) 0xC6;

    while (!(*UCSR0A & (1 << UDRE0)));
    *UDR0 = data;
}

int main() {
	
    uart_init();
    while (1) {
        uart_transmit('A'); // Send 'A'
		for (int i = 0; i < 1000; i++) {}
    }
    return 0;
}
