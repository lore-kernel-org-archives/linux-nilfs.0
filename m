From: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Subject: [PATCH 1/7] Add .gitignore rules for generated binaries
Date: Wed, 21 Dec 2011 15:34:03 -0600
Message-ID: <1324503249-17432-2-git-send-email-dan@archlinux.org>
References: <1324503249-17432-1-git-send-email-dan@archlinux.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=5kAnL79yTxgfEwVvxHjikC8HbxwkP/VV9bi+X1ROBPE=;
        b=qO3FLbUCXD5RXLtq9Y/pzwumwNKdxw+2mBBK4ofSX4D+TpJt79+YpBkqZh3eknt2qX
         Tppuca0pt72Zk3iXF6fU3qlPT0l7q9H/EfbjkBXBEJYVZB/1jJQEFO/mrIRs42Buls23
         DdEfH5y21EfiF7NbA4W7gAcfCo0cUfBpvSFBY=
In-Reply-To: <1324503249-17432-1-git-send-email-dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This ignores all of the generated binaries so git status is clean after
building the project.

Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
---
 bin/.gitignore               |    6 ++++++
 sbin/cleanerd/.gitignore     |    1 +
 sbin/mkfs/.gitignore         |    1 +
 sbin/mount/.gitignore        |    2 ++
 sbin/nilfs-clean/.gitignore  |    1 +
 sbin/nilfs-resize/.gitignore |    1 +
 sbin/nilfs-tune/.gitignore   |    1 +
 7 files changed, 13 insertions(+), 0 deletions(-)
 create mode 100644 bin/.gitignore
 create mode 100644 sbin/cleanerd/.gitignore
 create mode 100644 sbin/mkfs/.gitignore
 create mode 100644 sbin/mount/.gitignore
 create mode 100644 sbin/nilfs-clean/.gitignore
 create mode 100644 sbin/nilfs-resize/.gitignore
 create mode 100644 sbin/nilfs-tune/.gitignore

diff --git a/bin/.gitignore b/bin/.gitignore
new file mode 100644
index 0000000..3718690
--- /dev/null
+++ b/bin/.gitignore
@@ -0,0 +1,6 @@
+/chcp
+/dumpseg
+/lscp
+/lssu
+/mkcp
+/rmcp
diff --git a/sbin/cleanerd/.gitignore b/sbin/cleanerd/.gitignore
new file mode 100644
index 0000000..b39e825
--- /dev/null
+++ b/sbin/cleanerd/.gitignore
@@ -0,0 +1 @@
+/nilfs_cleanerd
diff --git a/sbin/mkfs/.gitignore b/sbin/mkfs/.gitignore
new file mode 100644
index 0000000..0d8a9d6
--- /dev/null
+++ b/sbin/mkfs/.gitignore
@@ -0,0 +1 @@
+/mkfs.nilfs2
diff --git a/sbin/mount/.gitignore b/sbin/mount/.gitignore
new file mode 100644
index 0000000..766f1bb
--- /dev/null
+++ b/sbin/mount/.gitignore
@@ -0,0 +1,2 @@
+/mount.nilfs2
+/umount.nilfs2
diff --git a/sbin/nilfs-clean/.gitignore b/sbin/nilfs-clean/.gitignore
new file mode 100644
index 0000000..96d31d6
--- /dev/null
+++ b/sbin/nilfs-clean/.gitignore
@@ -0,0 +1 @@
+/nilfs-clean
diff --git a/sbin/nilfs-resize/.gitignore b/sbin/nilfs-resize/.gitignore
new file mode 100644
index 0000000..2e82991
--- /dev/null
+++ b/sbin/nilfs-resize/.gitignore
@@ -0,0 +1 @@
+/nilfs-resize
diff --git a/sbin/nilfs-tune/.gitignore b/sbin/nilfs-tune/.gitignore
new file mode 100644
index 0000000..e8a1d3e
--- /dev/null
+++ b/sbin/nilfs-tune/.gitignore
@@ -0,0 +1 @@
+/nilfs-tune
-- 
1.7.8

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
