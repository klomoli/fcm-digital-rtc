# FCM Digital - Ruby Technical challenge

This project is a Ruby solution designed to parse and organize travel itinerary data from a text file input. The application reads and processes trip reservations, extracting relevant segment details to structure an itinerary that includes flights, trains, and hotel stays.

We receive the reservations of our user that we know is based on SVQ as:
```
# input.txt

RESERVATION
SEGMENT: Flight SVQ 2023-03-02 06:40 -> BCN 09:10

RESERVATION
SEGMENT: Hotel BCN 2023-01-05 -> 2023-01-10

RESERVATION
SEGMENT: Flight SVQ 2023-01-05 20:40 -> BCN 22:10
SEGMENT: Flight BCN 2023-01-10 10:30 -> SVQ 11:50

RESERVATION
SEGMENT: Train SVQ 2023-02-15 09:30 -> MAD 11:00
SEGMENT: Train MAD 2023-02-17 17:00 -> SVQ 19:30

RESERVATION
SEGMENT: Hotel MAD 2023-02-15 -> 2023-02-17

RESERVATION
SEGMENT: Flight BCN 2023-03-02 15:00 -> NYC 22:45
```

And we want to expose and UI like this:

```
TRIP to BCN
Flight from SVQ to BCN at 2023-01-05 20:40 to 22:10
Hotel at BCN on 2023-01-05 to 2023-01-10
Flight from BCN to SVQ at 2023-01-10 10:30 to 11:50

TRIP to MAD
Train from SVQ to MAD at 2023-02-15 09:30 to 11:00
Hotel at MAD on 2023-02-15 to 2023-02-17
Train from MAD to SVQ at 2023-02-17 17:00 to 19:30

TRIP to NYC
Flight from SVQ to BCN at 2023-03-02 06:40 to 09:10
Flight from BCN to NYC at 2023-03-02 15:00 to 22:45
```

## Overview

The solution is divided into three main services:

### 1. `FileReaderReservationsService`

Reads the input file and extracts the reservations. The service is responsible for identifying the type of reservation and extracting the relevant details to create a structured object.

### 2. `SegmentParserService`

Parses each RESERVATION section to extract segments, such as flights, trains, and hotels. The service is responsible for identifying the type of segment and extracting the relevant details to create a structured object.

### 3. `ItineraryOrganizerService`

Organizes the segments into trips based on the destination. The service is responsible for grouping the segments by destination and sorting them by date to create a structured itinerary.

## How to Run

This project is written in Ruby. To execute it:

1. Run the following command, where `file.txt` is the name of your input file:

   ```bash
   bundle install
   BASED=SVQ bundle exec ruby main.rb filex.txt
   ```
2. Run the test with Rspec
```bash
   bundle exec rspec
   ```
---
