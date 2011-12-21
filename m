From: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Subject: [PATCH 0/7] A handful of small cleanups and improvements
Date: Wed, 21 Dec 2011 15:34:02 -0600
Message-ID: <1324503249-17432-1-git-send-email-dan@archlinux.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        bh=W7K/PIqPgj0CPuwWJVjMJ4UkcaZuuhMKquC6mcm1kww=;
        b=jIIbvMjyQhpvEkpkWXGsgVwAx8ZJuV+GYMrD6LlFm9j+IgLn8bJkT9nK0TKuzmIGb3
         +sSDX7pkOhawRqsZaE/uUCZI0SlaiJDrOv3kAKNbZbhT0N9y7wKV0ykazcPISRllC3bD
         JuLrz+vaJImRYpZDyQLW1vSvHlRlVekOqPNUs=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is a short series of patches with some improvements and code cleanups.
Most should be rather independent of each other and I'm definitely open to any
feedback.

Dan McGee (7):
  Add .gitignore rules for generated binaries
  umount.nilfs2 (libmount): send proper error code to complain function
  Remove kern_compat.h
  Alpha sort AC_CHECK_FUNCS list in configure.ac
  Use strtoull instead of strtoul where applicable
  rmcp/chcp: sanity check for positive checkpoint number
  rmcp: print sensible error message on permission failure

 bin/.gitignore                 |    6 +++++
 bin/Makefile.am                |    2 +-
 bin/chcp.c                     |    7 +++--
 bin/dumpseg.c                  |    4 +-
 bin/rmcp.c                     |   10 +++++---
 configure.ac                   |    8 +++---
 include/Makefile.am            |    2 +-
 include/cno.h                  |    1 +
 include/kern_compat.h          |   47 ----------------------------------------
 lib/cno.c                      |   29 +++++++++++++++++------
 lib/feature.c                  |    2 +-
 sbin/cleanerd/.gitignore       |    1 +
 sbin/mkfs/.gitignore           |    1 +
 sbin/mkfs/mkfs.c               |    3 +-
 sbin/mkfs/mkfs.h               |    4 ---
 sbin/mount/.gitignore          |    2 +
 sbin/mount/umount_libmount.c   |    4 +--
 sbin/nilfs-clean/.gitignore    |    1 +
 sbin/nilfs-clean/nilfs-clean.c |    2 +-
 sbin/nilfs-resize/.gitignore   |    1 +
 sbin/nilfs-tune/.gitignore     |    1 +
 21 files changed, 58 insertions(+), 80 deletions(-)
 create mode 100644 bin/.gitignore
 delete mode 100644 include/kern_compat.h
 create mode 100644 sbin/cleanerd/.gitignore
 create mode 100644 sbin/mkfs/.gitignore
 create mode 100644 sbin/mount/.gitignore
 create mode 100644 sbin/nilfs-clean/.gitignore
 create mode 100644 sbin/nilfs-resize/.gitignore
 create mode 100644 sbin/nilfs-tune/.gitignore

-- 
1.7.8

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
