From: "volkov-6IceoeoMUCicTuHFI/JV5w@public.gmane.org" <volkov-6IceoeoMUCicTuHFI/JV5w@public.gmane.org>
Subject: Kernel patch
Date: Thu, 07 May 2009 14:46:00 +0400
Message-ID: <1241693160.5315.20.camel@flot-flash>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-6MQKDN0mweLwVh8CiZHz"
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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


--=-6MQKDN0mweLwVh8CiZHz
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

New patch is attached
(for 2.6.28 linux kernel)


INSTALL:
========================================================
# cd /usr/src/

save patch_nilfs

# wget 
https://www.nilfs.org/download/nilfs-2.0.12.tar.bz2
# tar -jxf nilfs-2.0.12.tar.bz2
# mv nilfs-2.0.12/fs linux/fs/nilfs
# rm -rf milfs-2.0.12
# cd linux
# patch -p 1 <../patch_nilfs
# make menuconfig

File systems  --->           
 <*> NILFS 

# make
# make install
========================================================


Oleg Volkov


--=-6MQKDN0mweLwVh8CiZHz
Content-Disposition: attachment; filename=patch_nilfs
Content-Type: text/x-patch; name=patch_nilfs; charset=KOI8-R
Content-Transfer-Encoding: 7bit

--- linux-2.6.28-gentoo-r5/fs/Kconfig	2009-05-02 10:14:13.370800000 +0400
+++ linux-2.6.28-gentoo-r5-nilfs/fs/Kconfig	2009-05-02 10:09:16.617795207 +0400
@@ -6,6 +6,11 @@
 
 if BLOCK
 
+config NILFS
+	tristate "NILFS"
+	help
+	  NILFS
+ 	  
 source "fs/ext2/Kconfig"
 source "fs/ext3/Kconfig"
 source "fs/ext4/Kconfig"
--- linux-2.6.28-gentoo-r5/fs/Makefile	2009-05-02 10:14:13.370800000 +0400
+++ linux-2.6.28-gentoo-r5-nilfs/fs/Makefile	2009-05-02 10:20:46.679359767 +0400
@@ -69,6 +69,7 @@
 obj-$(CONFIG_DLM)		+= dlm/
  
 # Do not add any filesystems before this line
+obj-$(CONFIG_NILFS)		+= nilfs/
 obj-$(CONFIG_REISERFS_FS)	+= reiserfs/
 obj-$(CONFIG_EXT3_FS)		+= ext3/ # Before ext2 so root fs can be ext3
 obj-$(CONFIG_EXT4_FS)		+= ext4/ # Before ext2 so root fs can be ext4

--=-6MQKDN0mweLwVh8CiZHz
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--=-6MQKDN0mweLwVh8CiZHz--

