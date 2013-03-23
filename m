From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] nilfs-utils: mkfs.nilfs2 should check presence of NILFS2
 volume on device
Date: Sat, 23 Mar 2013 15:45:22 +0400
Message-ID: <1364039122.16985.2.camel@slavad-ubuntu-12.04>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:From:Subject:Message-ID; bh=6GQ0s7aDYIAO6YkjoY9x1Bv96sLUvNL4DTAmCjf+QvA=;
	b=MwImCN7XwHtwqrPxyXaLVQzY7w9512uFp7j6vtyudgG7eTHGrKTaT7Nba/qW1M/QIiEnjjVKq/P9eaAWlGogsXuldpz7Z1tUWwa3RkXlYk+vERw/tAkmbewpC+gbyNTL;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Hendrik Levsen <hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org>

From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] nilfs-utils: mkfs.nilfs2 should check presence of NILFS2 volume on device

The mkfs.nilfs2 utility should check presence of NILFS2 volume on device and to warn a user about possibility to destroy data by mkfs activity. This patch tries to read and to validate checksums of primary and secondary superblocks on opened device. If this operation ends successfully then mkfs.nilfs2 informs a user about potential danger to destroy existing NILFS2 volume. The execution of mkfs.nilfs2 stops with offering to make decision about continuation or abortion of operation. However, if a user runs mkfs.nilfs2 with "-q" option then checking of NILFS2 volume is skipped.

Reported-by: Hendrik Levsen <hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org>
Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Tested-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
---
 sbin/mkfs/Makefile.am |    3 ++-
 sbin/mkfs/mkfs.c      |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/sbin/mkfs/Makefile.am b/sbin/mkfs/Makefile.am
index b3eb78a..631b04f 100644
--- a/sbin/mkfs/Makefile.am
+++ b/sbin/mkfs/Makefile.am
@@ -4,7 +4,8 @@ AM_CFLAGS = -Wall
 AM_CPPFLAGS = -I$(top_srcdir)/include
 LDADD = -luuid $(top_builddir)/lib/libnilfsfeature.la \
 	$(top_builddir)/lib/libmountchk.la \
-	$(top_builddir)/lib/libcrc32.la
+	$(top_builddir)/lib/libcrc32.la \
+	$(top_builddir)/lib/libnilfs.la
 
 sbin_PROGRAMS = mkfs.nilfs2
 
diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
index fde1c76..9f18afe 100644
--- a/sbin/mkfs/mkfs.c
+++ b/sbin/mkfs/mkfs.c
@@ -347,6 +347,8 @@ static int nilfs_mkfs_discard_zeroes_data(int fd)
 
 static void disk_scan(const char *device);
 static void check_mount(int fd, const char *device);
+static void check_presence_of_nilfs_volume_on_device(int fd,
+						const char *device);
 
 
 /*
@@ -611,6 +613,7 @@ int main(int argc, char *argv[])
 	if ((fd = open(device, O_RDWR)) < 0)
 		perr("Error: cannot open device: %s", device);
 	check_mount(fd, device);
+	check_presence_of_nilfs_volume_on_device(fd, device);
 
 	init_disk_layout(di, fd, device);
 	si = new_segment(di);
@@ -729,6 +732,37 @@ static void check_mount(int fd, const char *device)
 	fclose(fp);
 }
 
+static void check_presence_of_nilfs_volume_on_device(int fd,
+						const char *device)
+{
+	struct nilfs_super_block *sbp = NULL;
+	int c;
+
+	if (quiet == 0) {
+		sbp = nilfs_sb_read(fd);
+		if (sbp) {
+			free(sbp);
+
+			pinfo("WARNING: Device %s has NILFS2 superblocks.",
+				device);
+			pinfo("WARNING: All data will be lost after format!");
+			pinfo("\nDO YOU REALLY WANT TO FORMAT DEVICE %s?",
+				device);
+
+			do {
+				fprintf(stderr, "\nContinue? [y/N] ");
+				c = getchar();
+
+				if (c == 'n' || c == 'N' || c == EOF) {
+					close(fd);
+					perr("Abort format of device %s",
+						device);
+				}
+			} while (c != 'y' && c != 'Y');
+		}
+	}
+}
+
 static void destroy_disk_buffer(void)
 {
 	if (disk_buffer) {
-- 
1.7.9.5



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
