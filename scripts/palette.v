// palette generates a PNG palette preview image from hex colors.
//
// Usage:
//   v run palette.v <output.png> <color1> [color2 ...]
//   ./palette <output.png> <color1> [color2 ...]
//
// Example:
//   v run palette.v p.png #FF9300 #00FF00 #0000FF
//
// Dependencies: none (uses V's built-in stbi module for PNG output)

module main

import os
import stbi

fn main() {
    if os.args.len < 3 {
        println('Usage: ${os.args[0]} <output.png> <color1> [color2 ...]')
        println('Example: palette p.png #FF9300 #00FF00')
        exit(1)
    }

    output_file := os.args[1]
    colors_hex := os.args[2..]

    width := 240 * colors_hex.len
    height := 320
    footer_h := 40
    block_w := width / colors_hex.len

    mut pixels := []u8{len: width * height * 4, init: 255}

    for i, hex in colors_hex {
        x0 := i * block_w
        c := parse_hex(hex)
        for y := 0; y < height - footer_h; y++ {
            for x := x0; x < x0 + block_w; x++ {
                idx := (y * width + x) * 4
                pixels[idx] = c.r
                pixels[idx + 1] = c.g
                pixels[idx + 2] = c.b
                pixels[idx + 3] = 255
            }
        }
    }

    for y := height - footer_h; y < height; y++ {
        for x := 0; x < width; x++ {
            idx := (y * width + x) * 4
            pixels[idx] = 255
            pixels[idx + 1] = 255
            pixels[idx + 2] = 255
            pixels[idx + 3] = 255
        }
    }

    for i, hex in colors_hex {
        x := i * block_w + 12
        y := height - footer_h + 8
        draw_text(mut pixels, width, height, x, y, hex)
    }

    stbi.stbi_write_png(output_file, width, height, 4, unsafe { &pixels[0] }, width * 4)!
    println('Saved palette image to: ${output_file}')
}

struct Color {
    r u8
    g u8
    b u8
}

fn parse_hex(s string) Color {
    h := if s.starts_with('#') { s[1..] } else { s }
    v := u64_from_hex(h)
    return Color{
        r: u8((v >> 16) & 0xFF)
        g: u8((v >> 8) & 0xFF)
        b: u8((v >> 0) & 0xFF)
    }
}



fn draw_pixel(mut pixels []u8, width int, height int, x int, y int, r u8, g u8, b u8) {
    if x < 0 || x >= width || y < 0 || y >= height {
        return
    }
    idx := (y * width + x) * 4
    pixels[idx] = r
    pixels[idx + 1] = g
    pixels[idx + 2] = b
    pixels[idx + 3] = 255
}

fn draw_text(mut pixels []u8, width int, height int, x0 int, y0 int, text string) {
    for ci, ch in text {
        if ch < 32 || ch > 127 {
            continue
        }
        glyph := font_glyph(ch)
        for gy, row in glyph {
            for gx := 0; gx < 8; gx++ {
                if row & u8(1 << (7 - gx)) != 0 {
                    draw_pixel(mut pixels, width, height, x0 + ci * 10 + gx, y0 + gy, 0, 0, 0)
                }
            }
        }
    }
}

fn font_glyph(ch u8) []u8 {
    return match ch {
        `0` { [u8(0x00), 0x3E, 0x45, 0x49, 0x51, 0x61, 0x3E] }
        `1` { [u8(0x00), 0x18, 0x08, 0x08, 0x08, 0x08, 0x1C] }
        `2` { [u8(0x00), 0x3E, 0x41, 0x01, 0x02, 0x04, 0x7F] }
        `3` { [u8(0x00), 0x3E, 0x41, 0x0E, 0x01, 0x41, 0x3E] }
        `4` { [u8(0x00), 0x02, 0x06, 0x0A, 0x12, 0x7F, 0x02] }
        `5` { [u8(0x00), 0x7F, 0x40, 0x7E, 0x01, 0x41, 0x3E] }
        `6` { [u8(0x00), 0x1E, 0x20, 0x40, 0x7E, 0x41, 0x3E] }
        `7` { [u8(0x00), 0x7F, 0x01, 0x02, 0x04, 0x08, 0x08] }
        `8` { [u8(0x00), 0x3E, 0x41, 0x3E, 0x41, 0x41, 0x3E] }
        `9` { [u8(0x00), 0x3E, 0x41, 0x3F, 0x01, 0x02, 0x3C] }
        `A` { [u8(0x00), 0x08, 0x14, 0x22, 0x3E, 0x41, 0x41] }
        `B` { [u8(0x00), 0x7E, 0x41, 0x7E, 0x41, 0x41, 0x7E] }
        `C` { [u8(0x00), 0x1E, 0x21, 0x40, 0x40, 0x21, 0x1E] }
        `D` { [u8(0x00), 0x7C, 0x42, 0x41, 0x41, 0x42, 0x7C] }
        `E` { [u8(0x00), 0x7F, 0x40, 0x7E, 0x40, 0x40, 0x7F] }
        `F` { [u8(0x00), 0x7F, 0x40, 0x7E, 0x40, 0x40, 0x40] }
        `#` { [u8(0x00), 0x14, 0x14, 0x7F, 0x14, 0x7F, 0x14] }
        else { []u8{} }
    }
}

fn u64_from_hex(s string) u64 {
    mut result := u64(0)
    for c in s {
        match c {
            `0`...`9` {
                result = result << 4 | u64(c - `0`)
            }
            `A`...`F` {
                result = result << 4 | u64(c - `A` + 10)
            }
            `a`...`f` {
                result = result << 4 | u64(c - `a` + 10)
            }
            else {
                break
            }
        }
    }
    return result
}
