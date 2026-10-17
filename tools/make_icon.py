#!/usr/bin/env python3
"""Draw the RPBot Studio icon from code so it can be tweaked and regenerated.

    python tools/make_icon.py      (needs Pillow; only for regenerating)

A top-down robot with LiDAR scan arcs on the studio's ink and blue. Writes a multi-size
.ico (Windows window, taskbar, EXE), a 40 px .png for the header and a 256 px .png for
the Linux window and launcher.
"""
import math
from pathlib import Path

from PIL import Image, ImageDraw

ASSETS = Path(__file__).resolve().parent.parent / 'assets'
CANVAS = 1024
ICO_SIZES = (16, 20, 24, 32, 40, 48, 64, 96, 128, 256)

INK = (16, 16, 20, 255)          # studio_theme.INK
INK_EDGE = (58, 58, 66, 255)
BLUE = (45, 129, 255, 255)       # studio_theme.BLUE
WHITE = (255, 255, 255, 255)


def disc(draw, x, y, r, fill):
    draw.ellipse((x - r, y - r, x + r, y + r), fill=fill)


def arc(draw, x, y, r, start, end, width, fill):
    """Arc with round caps; angles in degrees, clockwise from 3 o'clock like Pillow."""
    draw.arc((x - r, y - r, x + r, y + r), start, end, fill=fill, width=width)
    mid = r - width / 2
    for angle in (start, end):
        a = math.radians(angle)
        disc(draw, x + mid * math.cos(a), y + mid * math.sin(a), width / 2, fill)


def icon():
    image = Image.new('RGBA', (CANVAS, CANVAS), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle((16, 16, CANVAS - 17, CANVAS - 17), radius=210, fill=INK, outline=INK_EDGE, width=20)
    cx, cy = 512, 640
    for radius in (330, 455):
        arc(draw, cx, cy, radius, 222, 318, 58, BLUE)
    for side in (-1, 1):
        x = cx + side * 250
        draw.rounded_rectangle((x - 34, cy - 92, x + 34, cy + 92), radius=26, fill=WHITE)
    disc(draw, cx, cy, 246, INK)
    disc(draw, cx, cy, 218, WHITE)
    disc(draw, cx, cy, 104, INK)
    disc(draw, cx, cy, 70, BLUE)
    return image


if __name__ == '__main__':
    image = icon()
    frames = [image.resize((size, size), Image.LANCZOS) for size in ICO_SIZES]
    frames[-1].save(ASSETS / 'rpbot-studio.ico', sizes=[(s, s) for s in ICO_SIZES], append_images=frames[:-1])
    image.resize((40, 40), Image.LANCZOS).save(ASSETS / 'rpbot-studio.png', optimize=True)
    frames[-1].save(ASSETS / 'rpbot-studio-256.png', optimize=True)
    print('wrote', *(ASSETS / name for name in ('rpbot-studio.ico', 'rpbot-studio.png', 'rpbot-studio-256.png')))
