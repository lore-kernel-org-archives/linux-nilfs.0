From: Oleg Volkov <volkov-6IceoeoMUCicTuHFI/JV5w@public.gmane.org>
Subject: Re: root nilfs
Date: Mon, 16 Mar 2009 09:35:56 +0300
Message-ID: <1237185357.7448.14.camel@flot.hovrino.net>
References: <mailman.1.1237172401.5975.users@nilfs.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-dSppr04CzqSO06jiAkLc"
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <mailman.1.1237172401.5975.users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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


--=-dSppr04CzqSO06jiAkLc
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

I used nilfs root.
On Gentoo Linux.

Patch attached. And copy nilfs to kernel tree.
--
Oleg Volkov

--=-dSppr04CzqSO06jiAkLc
Content-Disposition: attachment; filename=patch_nilfs
Content-Type: text/x-patch; name=patch_nilfs; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -u linux-2.6.25-gentoo-r4/fs/Kconfig linux-2.6.25-gentoo-r4-nilfs/fs/Kconfig
--- linux-2.6.25-gentoo-r4/fs/Kconfig	2008-06-12 10:25:51.000000000 +0400
+++ linux-2.6.25-gentoo-r4-nilfs/fs/Kconfig	2008-06-24 22:54:57.896321887 +0400
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
diff -u linux-2.6.25-gentoo-r4/fs/Makefile linux-2.6.25-gentoo-r4-nilfs/fs/Makefile
--- linux-2.6.25-gentoo-r4/fs/Makefile	2008-06-12 10:25:51.000000000 +0400
+++ linux-2.6.25-gentoo-r4-nilfs/fs/Makefile	2008-06-24 22:56:26.481197446 +0400
@@ -66,6 +66,7 @@
 obj-$(CONFIG_DLM)		+= dlm/
  
 # Do not add any filesystems before this line
+obj-$(CONFIG_NILFS)	+= nilfs/
 obj-$(CONFIG_REISERFS_FS)	+= reiserfs/
 obj-$(CONFIG_EXT3_FS)		+= ext3/ # Before ext2 so root fs can be ext3
 obj-$(CONFIG_EXT4DEV_FS)	+= ext4/ # Before ext2 so root fs can be ext4dev

--=-dSppr04CzqSO06jiAkLc
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--=-dSppr04CzqSO06jiAkLc--

