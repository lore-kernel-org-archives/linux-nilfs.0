From: volkov-6IceoeoMUCicTuHFI/JV5w@public.gmane.org
Subject: [SPAM]  Re: users Digest, Vol 27, Issue 3
Date: Fri, 27 Jun 2008 10:03:31 +0400 (MSD)
Message-ID: <60424.87.251.152.38.1214546611.squirrel@mail.teratelecom.ru>
References: <mailman.1.1214535602.30509.users@nilfs.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <mailman.1.1214535602.30509.users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

>> I installed Linux system on nilfs root partition
>> I use 2x32G usb flash (raid0, 64k chunks).
>> Nilfs with "-B 512."
>>
>> I use gentoo linux.
>> I had to remove the script / etc / init.d / checkroot.
>>
>> mount.nilfs2 does not understand the command:
>> mount -o remount, ro /
>> mount -o remount, rw /
>> mount -f ...
>>
>> Fixed please.
>
> Please let me know some details.
>
> How did you load the NILFS2 module (nilfs2.ko)
> before mounting the root partition created by NILFS2 ?
> Are you using an initrd image with nilfs2.ko ?

I patch kernel sources

--- linux-2.6.25-gentoo-r4/fs/Kconfig	2008-06-12 10:25:51.000000000 +0400
+++ linux-2.6.25-gentoo-r4-nilfs/fs/Kconfig	2008-06-24 22:54:57.000000000
+0400
@@ -6,6 +6,11 @@

 if BLOCK

+config NILFS
+	tristate "NILFS"
+	help
+	  NILFS
+
 config EXT2_FS
 	tristate "Second extended fs support"
 	help
--- linux-2.6.25-gentoo-r4/fs/Makefile	2008-06-12 10:25:51.000000000 +0400
+++ linux-2.6.25-gentoo-r4-nilfs/fs/Makefile	2008-06-24 22:56:26.000000000
+0400
@@ -66,6 +66,7 @@
 obj-$(CONFIG_DLM)		+= dlm/

 # Do not add any filesystems before this line
+obj-$(CONFIG_NILFS)	+= nilfs/
 obj-$(CONFIG_REISERFS_FS)	+= reiserfs/
 obj-$(CONFIG_EXT3_FS)		+= ext3/ # Before ext2 so root fs can be ext3
 obj-$(CONFIG_EXT4DEV_FS)	+= ext4/ # Before ext2 so root fs can be ext4dev

and copy nilfs to kernel sources

# cp -a nilfs-2.0.2/fs linux-2.6.25-gentoo-r4-nilfs/fs/nilfs/

# grep NILFS linux-2.6.25-gentoo-r4-nilfs/.config
CONFIG_NILFS=y

# sfdisk -d /dev/sdb
unit: sectors

/dev/sdb1 : start=       32, size=   100320, Id=fd, bootable
/dev/sdb2 : start=   100352, size= 62552064, Id=fd
/dev/sdb3 : start=        0, size=        0, Id= 0
/dev/sdb4 : start=        0, size=        0, Id= 0

raid1(sdb1+sdc1), xfs, /boot
raid0(sdb2+sdc2), nilfs, /

In /etc/lilo.conf:
lba32
boot = /dev/md1
map = /boot/.map
raid-extra-boot = mbr-only
install = /boot/boot-menu.b
menu-scheme=Wb
prompt
timeout = 50
delay = 30
vga = normal
default = Gentoo

image = /boot/vmlinuz
	root = /dev/md0
	label = Gentoo
	append="pci=nommconf usbcore.autosuspend=1 snd_ac97_codec.power_save=1
acpi_irq_balance=0 nmi_watchdog=0 rootdelay=8"
	read-write
image = /boot/vmlinuz.old
	root = /dev/md0
	label = old
	append="pci=nommconf"
	read-write

In /etc/fstab:
/dev/md0	/		nilfs2	defaults		0 0
proc		/proc		proc	defaults		0 0
shm		/dev/shm	tmpfs	nodev,nosuid,noexec	0 0
shm		/var/tmp	tmpfs	noatime			0 0


> What kind of message was printed in the problem,
> or did it hang up ?

# mount -f /
/sbin/mount.nilfs2: invalid option -- f


mount -o remount,ro /
mount -o remount,rw /
It's my mistake.
I did not correctly /etc/fstab

---
Oleg Volkov
