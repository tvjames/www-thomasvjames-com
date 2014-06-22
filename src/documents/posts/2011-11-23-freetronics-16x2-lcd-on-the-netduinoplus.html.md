---
author: tvjames
comments: true
date: 2011-11-23 09:14:39+00:00
layout: post
slug: freetronics-16x2-lcd-on-the-netduinoplus
title: Freetronics 16x2 LCD on the NetduinoPlus
wordpress_id: 216
---

Since I got my netduino, and shortly after the netduino plus, I've been dying to get a few accessories to play with. Making the on-board LED flash isn't the most exciting thing in the world. So when [Little Bird Electronics](), the guys i bought the netduino from, advertised a one day 20% all freetronics gear sale i jumped on the chance to grab a few accessories and with next day express shipping for $8 it was a no-brainer.

The haul:

  1. [16x2 LCD using HD44780-compatible display & keypad shield](http://littlebirdelectronics.com/products/lcd-keypad-shield-1)
  2. [AM3X Accelerometer Module](http://littlebirdelectronics.com/products/3-axis-accelerometer-module)
  3. [433Mhz receiver shield](http://littlebirdelectronics.com/products/433mhz-receiver-shield-for-arduino)

Getting it up and running wasn't the simplest task for a non-electrical-engineer software developer like myself. I scoured the internet for articles & blog posts of someone that had done it before me, but alas, there were none. So i started to research how i would do it on the Arduino and how others have got lcd panels working no the netduinos. It also doesn't help that the MicroFramework doesn't have an LCD display library built-in for the task.

Thanks to articles below however there is hope, the LCD library for the Arduino has been ported  and is available on codeplex as the [μLiquidCrystal](http://microliquidcrystal.codeplex.com/). Reading the articles and the example code that came with the library i was able to determine i could use the direct GPIO TransferProvider. The freetronics LCD goes one step further and allows you to just line up the pin labels on the LCD with the labels on the netduino and use those as the GPIO inputs to the TransferProvider.

Code to initialise the freetronics 16x2 LCD:

```
// initialise the LCD display
var ledPort = new OutputPort(Pins.ONBOARD_LED, false);
var backlightPort = new OutputPort(Pins.GPIO_PIN_D3, false);
var lcdProvider = new MicroLiquidCrystal.GpioLcdTransferProvider(
    Pins.GPIO_PIN_D8,  // RS
    Pins.GPIO_PIN_D9,  // ENABLE
    Pins.GPIO_PIN_D4,  // D4
    Pins.GPIO_PIN_D5,  // D5
    Pins.GPIO_PIN_D6,  // D6
    Pins.GPIO_PIN_D7); // D7
var lcd = new Lcd(lcdProvider);
lcd.Begin(16, 2);
```

Code to update the display:

```
lcd.Clear();
lcd.SetCursorPosition(2, 0);

lcd.Write("Ready ... ");

while (true)
{
    // set the cursor to column 0, line 1
    lcd.SetCursorPosition(0, 1);

    // print the number of seconds since reset:
    lcd.Write((Utility.GetMachineTime()).ToString());

    ledPort.Write(true);
    Thread.Sleep(350);

    ledPort.Write(false);
    Thread.Sleep(250);
}
```

Running display:
[![](http://www.thomasvjames.com/wp-content/uploads/2011/11/IMG_20111123_190923-300x224.jpg)](http://www.thomasvjames.com/wp-content/uploads/2011/11/IMG_20111123_190923.jpg)

References:

  * [.NET Micro Framework – Using alphanumeric LCDs](http://geekswithblogs.net/kobush/archive/2010/09/05/netmf_liquid_crystal.aspx)
  * [Using a 4x20 HD44780-controlled LCD Display with the Netduino](http://10rem.net/blog/2010/09/24/using-a-4x20-hd44780-controlled-lcd-display-with-the-netduino)

