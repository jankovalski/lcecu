#pragma once
#define KNOCK_ADC ADCD3
#define KNOCK_ADC_CH1 ADC_CHANNEL_IN14
#define KNOCK_PIN_CH1 Gpio::F4
#define KNOCK_SAMPLE_TIME ADC_SAMPLE_84
#define KNOCK_SAMPLE_RATE (STM32_PCLK2 / (4 * (84 + 12)))