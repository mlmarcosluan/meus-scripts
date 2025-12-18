#!/bin/bash

INFO=$(playerctl -p spotify metadata --format "{{title}} - {{artist}}")



echo "<txt>$INFO</txt>"