From: Christian Smith <csmith-r5H9PUQoNxUga4AWyxku7ULnMzgEhdHr@public.gmane.org>
Subject: Linux Mint Debian Edition with NILFS
Date: Tue, 15 Nov 2011 16:19:07 +0000
Message-ID: <20111115161907.GP750@csmith-bm.vm.bytemark.co.uk>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

For ages, I've been lurking on nilfs.org looking for some distribution
support for NILFS, with little being forthcoming. I resorted to 
manually transferring installations to NILFS root filesystem based
on Ubuntu and Debian install images in the past, but have recently
tried LMDE with the hope of modifying it's installer to support
NILFS.

Turns out, I didn't need to modify anything, as it pretty much supports
installation to NILFS out of the box. Booting from the live CD, I:

- In a shell window, run:
   sudo apt-get update && sudo apt-get install util-linux nilfs-tools
  This will install the nilfs compatible blkid (default is 2.17)
- Run the installer from the desktop
- When partitioning in gparted, just create your NILFS partition as ext4.
- Back in the installer, choose the newly created ext4 partition, configure
  it as / and use the pull down menu to format it as nilfs.
- Do the rest of the installation as directed by the installer.

Once the installer has finished, you should have your root environment
almost ready to go, but not quite. The default install won't include the
nilfs2 kernel module in the initramfs, so you'll have to update this by hand
before rebooting:

- In a shell, mount your new root partition:
   sudo mount /dev/blah /target
- Add the nilfs2 kernel module to the list of modules to include in initramfs:
   echo nilfs2 | sudo tee -a /target/etc/initramfs-tools/modules
- Update initramfs (proc needed):
   sudo mount --bind /proc /target/proc
   sudo chroot /target /usr/sbin/update-initramfs -u

Reboot, and enjoy your new NILFS root installation.

Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
