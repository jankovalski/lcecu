#include "pch.h"

static void setInjectorPins() {
	engineConfiguration->injectionPins[0] = Gpio::E14;
	engineConfiguration->injectionPins[1] = Gpio::E15;
	engineConfiguration->injectionPins[2] = Gpio::B12;
	engineConfiguration->injectionPins[3] = Gpio::D8;
	engineConfiguration->injectionPins[4] = Gpio::G12;
	engineConfiguration->injectionPins[5] = Gpio::G14;
}

static void setIgnitionPins() {
	engineConfiguration->ignitionPins[0] = Gpio::E3;
	engineConfiguration->ignitionPins[1] = Gpio::E2;
	engineConfiguration->ignitionPins[2] = Gpio::D13;
	engineConfiguration->ignitionPins[3] = Gpio::D12;
	engineConfiguration->ignitionPins[4] = Gpio::G10;
	engineConfiguration->ignitionPins[5] = Gpio::G9;
}

static void setEtbConfig() {
	engineConfiguration->etbIo[0].controlPin = Gpio::E9;
	engineConfiguration->etbIo[0].directionPin1 = Gpio::E8;
	engineConfiguration->etbIo[0].disablePin = Gpio::E10;
	engineConfiguration->etbIo[0].directionPin2 = Gpio::Unassigned;
	engineConfiguration->etb_use_two_wires = false;
}

static void setupVbatt() {
	engineConfiguration->analogInputDividerCoefficient = 1.516f;
	engineConfiguration->vbattDividerCoeff = (3.277 + 0.51) / 0.51;
	engineConfiguration->vbattAdcChannel = EFI_ADC_13;
	engineConfiguration->adcVcc = 3.3f;
}

/*static void setStepperConfig() {
	engineConfiguration->idle.stepperDirectionPin = Gpio::F7;
	engineConfiguration->idle.stepperStepPin = Gpio::F8;
	engineConfiguration->stepperEnablePin = Gpio::F9;
}*/

Gpio getCommsLedPin() {
	return Gpio::Unassigned;
}

Gpio getRunningLedPin() {
	return Gpio::Unassigned;
}

Gpio getWarningLedPin() {
	return Gpio::Unassigned;
}

void setBoardConfigOverrides() {
	setupVbatt();
	setEtbConfig();
	//setStepperConfig();

	engineConfiguration->clt.config.bias_resistor = 2200;
	engineConfiguration->iat.config.bias_resistor = 2200;

	engineConfiguration->canRxPin = Gpio::D0;
	engineConfiguration->canTxPin = Gpio::D1;

	engineConfiguration->is_enabled_spi_3 = true;
	engineConfiguration->spi3mosiPin = Gpio::C12;
	engineConfiguration->spi3misoPin = Gpio::C11;
	engineConfiguration->spi3sckPin = Gpio::C10;
}

void setBoardDefaultConfiguration(void) {
	setInjectorPins();
	setIgnitionPins();

	engineConfiguration->sdCardSpiDevice = SPI_DEVICE_3;
	engineConfiguration->isSdCardEnabled = true;
	engineConfiguration->sdCardCsPin = Gpio::D2;

	engineConfiguration->canWriteEnabled = true;
	engineConfiguration->canReadEnabled = true;
	engineConfiguration->canSleepPeriodMs = 50;

	engineConfiguration->canBaudRate = B500KBPS;

	engineConfiguration->enableSoftwareKnock = true;
}