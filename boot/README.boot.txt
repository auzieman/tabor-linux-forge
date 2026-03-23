Tabor USB test bundle
=====================

This bundle is intended for non-destructive board bring-up.

Contents:
- boot/zImage
- boot/tabor-a1222.dtb
- menu/boot.cmd.txt
- menu/boot.scr.txt

Suggested workflow:
1. Copy the bundle contents to a FAT-formatted USB stick.
2. Boot the A1222 into firmware / U-Boot.
3. Load the kernel and DTB manually first.
4. Keep internal disks untouched until serial boot is proven.

The initial goal is serial-console and early hardware validation, not
replacement of the installed operating system.
