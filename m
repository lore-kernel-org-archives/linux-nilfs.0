From: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Subject: [PATCH 2/7] umount.nilfs2 (libmount): send proper error code to complain function
Date: Wed, 21 Dec 2011 15:34:04 -0600
Message-ID: <1324503249-17432-3-git-send-email-dan@archlinux.org>
References: <1324503249-17432-1-git-send-email-dan@archlinux.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=rXYXFAYLMovE1l83UuHLViRB9OURJhug0OfEwP5ZFt0=;
        b=H4aPQvp77O3jqBGmHNtNgsM3SYu6I1jJgcIXFL2VtBy9J5DRl8KCRPg6978N9/jgCT
         5EOoaTOU17FQrSKC7SUiV8ZW9Q/zS3pIcBFV0pGUYg20xJAEgCZOHj5N49Kpp0i4M3N/
         4fyC5YjBZ2U6gwcHBQzqpaaNaT+ymicEguBXQ=
In-Reply-To: <1324503249-17432-1-git-send-email-dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

We were negating the error code sent to complain, which is wrong. The
documentation of mnt_context_do_umount() states that errors returned
from the umount() syscall will be returned >0, so we shouldn't be
doing a switch on the negated value. This fixes the following
non-helpful output:

Before:
    sudo sbin/mount/umount.nilfs2 /mnt/nilfs
    umount.nilfs2: /dev/loop0: Unknown error -16

After:
    $ sudo sbin/mount/umount.nilfs2 /mnt/nilfs
    umount.nilfs2: /dev/loop0: device is busy

Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
---

The complain() function was copied from the original umount code; I removed the
comment as it doesn't make much sense in the context of using libmount and not
parsing fstab directly.

 sbin/mount/umount_libmount.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/sbin/mount/umount_libmount.c b/sbin/mount/umount_libmount.c
index 939c6b0..2c983b3 100644
--- a/sbin/mount/umount_libmount.c
+++ b/sbin/mount/umount_libmount.c
@@ -183,8 +183,6 @@ static void complain(int err, const char *dev)
 		error(_("%s: %s: I/O error while unmounting"), progname, dev);
 		break;
 	case EBUSY:
-		/* Let us hope fstab has a line "proc /proc ..."
-		   and not "none /proc ..."*/
 		error(_("%s: %s: device is busy"), progname, dev);
 		break;
 	case ENOENT:
@@ -284,7 +282,7 @@ static int nilfs_umount_one(struct nilfs_umount_info *umi)
 	if (!mnt_context_is_fake(umi->cxt)) {
 		res = nilfs_do_umount_one(umi);
 		if (res) {
-			complain(-res, mnt_context_get_source(umi->cxt));
+			complain(res, mnt_context_get_source(umi->cxt));
 			goto failed;
 		}
 	}
-- 
1.7.8

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
