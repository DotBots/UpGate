# UpGate

Over-the-air dynamic reconfiguration of FPGA library and example application.

## Introduction

UpGate takes as input a binary bitstream and works with memory cells based FPGA.
UpGate requires a Flash memory, attached to both the FPGA and the microcontroller,
and compatible with JEDEC SPI protocol.

The [dotbot-upgate.py](../dist/scripts/dotbot-upgate.py) Python
script serves as the "Update controller" used to send the bitstream over-the-air
to the FPGA, via the "Embedded server" running on the microcontroller.

For better speed and power consumption performances, the bitstream can be sent
compressed (Gzip andn LZ4 compression methods available).

## Get the code

This repository uses [DotBot-libs](https://github.com/DotBots/DotBot-libs) as a
[Git submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules).
To clone the repository use the following command:

```
git clone --recurse-submodules https://github.com/DotBots/UpGate
```

## Security

Before running [dotbot-upgate.py](../dist/scripts/dotbot-upgate.py), it is
required to run the [generate_keys.py](../dist/scripts/generate_keys.py) script
to create the public/private key pair that are used by the Ed25519 signature
procotol.

## Hardware Setup

Upgate is meant to work with this setup:
- A Nordic nRF52840DK board running the embedded server and connected via SPI the
  FPGA Flash memory. An embedded server sample application code is provided
  [here](https://github.com/DotBots/UpGate/tree/main/app/app)
- A Nordic nNRF52840DK running the gateway application provided
  [here](https://github.com/DotBots/Dotbot-firmware/tree/main/projects/dotbot_gateway).
  A precompiled version can be downloaded
  [there](https://github.com/DotBots/DotBot-firmware/releases/download/REL-1.17/dotbot_gateway-nrf52840dk.hex)
  and flashed using the nRF52840DK instructions provided in
  [this section of the documentation](https://dotbot-firmware.readthedocs.io/en/latest/getting_started.html#download-and-flash-the-dotbot-gateway-application-firmware).

The SPI pins used to wire up the embedded server with the Flash memory are:

| Function | Port | Pin |
| -------- | ---- | --- |
| SCK      |    1 |  15 |
| MISO     |    1 |  14 |
| MOSI     |    1 |  13 |
| CS       |    1 |  12 |
| PROG     |    1 |  11 |

The PROG pin is used to trigger the reconfiguration of the FPGA once the new
bitstream has be written with success to the Flash memory.

## Installation

Among different common Python packages, this script requires the
[pydotbot](https://pypi.org/project/pydotbot/) package to be installed on the
system.

To install all the Python dependencies (pydotbot, cryptography, click and tqdm), run:

```
pip install -r dist/scripts/upgate/requirements.txt
```

## Cite this work

If you plan to reuse this work for a publication, consider citing it with:

```
UpGate: Low-Power and Secure Over-the-Air Hardware Reconfiguration for Deployed FPGAs
Alexandre Abadie , Alfonso Cortes-Neira , Thomas Watteyne , Filip Maksimovic
ICIN 2025 - 28th Conference on Innovation in Clouds, Internet and Networks, Mar 2025, Paris, France. pp.28-35, ⟨10.1109/ICIN64016.2025.10942953⟩
```
