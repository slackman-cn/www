---
title: BootCD
since: 202412
---

# Bootable CD iso

https://github.com/syzdek/efibootiso
```
mkdir -p efibootiso
cd efibootiso
mkdir -p EFI/BOOT
mkdir -p boot/grub/x86_64-efi

curl -o boot/vmlinuz \
   https://mirrors.kernel.org/slackware/slackware64-current/kernels/huge.s/bzImage
curl -o boot/initrd.img \
   https://mirrors.kernel.org/slackware/slackware64-current/isolinux/initrd.img

EFI/BOOT/{BOOTx64.EFI BOOTIA32.EFI}
bootx64.efi ---------UEFI的必需引导文件
```

## Example

```
sudo xorriso -as mkisofs \
	--modification-date=2024122615551800\
	--protective-msdos-label \
	-volid "ALPINE_TEAISO" \
	-appid "Alpine Linux Live/Rescue Media" \
	-publisher "Alpine Linux <https://alpinelinux.org>" \
	-preparer "Prepared by TeaISO v2" \
	-r -graft-points -no-pad \
	--sort-weight 0 / \
	--sort-weight 1 /boot \
	--grub2-mbr /data/isowork/boot/grub/i386-pc/boot_hybrid.img \
	-iso_mbr_part_type 0x83 \
	-isohybrid-gpt-basdat \
	-partition_offset 16 \
	-b boot/grub/i386-pc/eltorito.img \
	-c boot.catalog \
	-no-emul-boot -boot-load-size 4 -boot-info-table --grub2-boot-info \
	-eltorito-alt-boot \
	-append_partition 2 0xef /data/isowork/efi.img \
	-append_partition 3 0x83 /data/writable.img \
	-e --interval:appended_partition_2:all:: \
	-no-emul-boot \
	--mbr-force-bootable \
	-apm-block-size 512 \
	-partition_cyl_align off \
	-full-iso9660-filenames \
	-iso-level 3 -rock -joliet \
	-o example.iso \
	/data/isowork/
```


## Grub2

makearchiso, teaiso, liveslack

https://samwhelp.github.io/note-about-archlinux/read/core/iso/build-iso/start-build-arch-iso.html

https://fedoraproject.org/wiki/LiveOS_image  
https://www.gnu.org/software/grub/manual/legacy/Making-a-GRUB-bootable-CD_002dROM.html  
https://docs.fedoraproject.org/en-US/quick-docs/grub2-bootloader/  

https://github.com/nanoant/efi.git  
https://mvallim.github.io/live-custom-ubuntu-from-scratch/  
https://www.cnblogs.com/searchstar/p/18437677  

## isolinux

https://mvallim.github.io/live-custom-ubuntu-from-scratch/

```
mkdir -p image/{casper,isolinux,install}
cp /boot/vmlinuz-**-**-generic image/casper/vmlinuz
cp /boot/initrd.img-**-**-generic image/casper/initrd

sudo apt install isolinux
sudo apt install syslinux
cp /usr/lib/ISOLINUX/isolinux.bin image/isolinux/ 
cp /usr/lib/syslinux/modules/bios/* image/isolinux/
```

isolinux/isolinux.cfg
```
UI vesamenu.c32

MENU TITLE Boot Menu
DEFAULT linux
TIMEOUT 600
MENU RESOLUTION 640 480
MENU COLOR border       30;44   #40ffffff #a0000000 std
MENU COLOR title        1;36;44 #9033ccff #a0000000 std
MENU COLOR sel          7;37;40 #e0ffffff #20ffffff all
MENU COLOR unsel        37;44   #50ffffff #a0000000 std
MENU COLOR help         37;40   #c0ffffff #a0000000 std
MENU COLOR timeout_msg  37;40   #80ffffff #00000000 std
MENU COLOR timeout      1;37;40 #c0ffffff #00000000 std
MENU COLOR msg07        37;40   #90ffffff #a0000000 std
MENU COLOR tabmsg       31;40   #30ffffff #00000000 std

LABEL linux
 MENU LABEL Try Ubuntu FS
 MENU DEFAULT
 KERNEL /casper/vmlinuz
 APPEND initrd=/casper/initrd boot=casper

LABEL linux
 MENU LABEL Try Ubuntu FS (nomodeset)
 MENU DEFAULT
 KERNEL /casper/vmlinuz
 APPEND initrd=/casper/initrd boot=casper nomodeset
```
