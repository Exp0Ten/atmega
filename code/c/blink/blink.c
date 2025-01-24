// Default clock source is internal 8MHz RC oscillator
#define F_CPU 16000000UL

#include <avr/io.h>
#include <util/delay.h>

int main()
{
  DDRB |= (1 << PB5);

  while (1)
  {
    PORTB |= (1 << PB5);
    _delay_ms(1000);
    PORTB &= ~(1 << PB5);
    _delay_ms(1000);
  }
  return 0;
}
