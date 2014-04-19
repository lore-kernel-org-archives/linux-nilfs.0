From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 2/4] nilfs-utils: fix typos in manpages
Date: Sun, 20 Apr 2014 00:14:13 +0900
Message-ID: <1397920455-373-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1397920455-373-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1397920455-373-1-git-send-email-konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Fix typos in man/mount.nilfs2.8 and man/nilfs-resize.8.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 man/mount.nilfs2.8 | 4 ++--
 man/nilfs-resize.8 | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/man/mount.nilfs2.8 b/man/mount.nilfs2.8
index 37474e9..8f0115e 100644
--- a/man/mount.nilfs2.8
+++ b/man/mount.nilfs2.8
@@ -37,7 +37,7 @@ the \fI/etc/fstab\fP table.
 The third form, which directly invokes \fBmount.nilfs2\fP, is also
 usable since \fBmount.nilfs2\fP maintains by itself the system mount
 state such as the list of mounted file systems described in
-\fI/etc/mtab\fP. Howerver, the first or the second form is usually
+\fI/etc/mtab\fP. However, the first or the second form is usually
 recommended because some expansive options are not supported by the
 third form.
 .SH OPTIONS
@@ -103,7 +103,7 @@ checkpoints marked as snapshot are mountable with this option.  Note
 that the read-only mount option must be specified together.
 .TP
 .BR errors=continue " / " errors=remount-ro " / " errors=panic
-Define the behaviour when an error is encountered.  (Eigher ignore
+Define the behaviour when an error is encountered.  (Either ignore
 errors and just mark the file system erroneous and continue, or
 remount the file system read-only, or panic and halt the system.)  The
 default is remount-ro.  In earlier kernels than Linux 2.6.35, continue
diff --git a/man/nilfs-resize.8 b/man/nilfs-resize.8
index 99ed930..b05982e 100644
--- a/man/nilfs-resize.8
+++ b/man/nilfs-resize.8
@@ -19,7 +19,7 @@ filesystem.  The \fIsize\fP of the filesystem may never be larger than
 the size of the partition.  Optionally, the \fIsize\fP parameter may
 be suffixed by one of the following units designators: \'s\',
 \'K\', \'M\', \'G\', or \'T\', for 512 byte sectors, kilobytes,
-magabytes, gigabytes, or terabytes, respectively.  If \fIsize\fP
+megabytes, gigabytes, or terabytes, respectively.  If \fIsize\fP
 parameter is not specified, it will default to the size of the
 partition.
 .PP
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
