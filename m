From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 8/8] update manpages to indicate open-by-mountpoint
Date: Thu,  3 Mar 2011 13:47:52 +0100
Message-ID: <1299156472-4707-8-git-send-email-dexen.devries@gmail.com>
References: <20110302.232110.169818198.ryusuke@osrg.net>
 <1299156472-4707-1-git-send-email-dexen.devries@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:message-id:x-mailer
         :in-reply-to:references:x-face;
        bh=jPho7bpgsCirxRPViux/HBe1UJrVFfQssHlNfHRQbMs=;
        b=R70CKFhXpb5aTgJ5RfEreDF1RwdgmbDXTJeLuxqnQQRljDkBHHsHoPmzydjBQ+vFJp
         DiytDFxoEdOo/VdDZocXoI7FvfopK2NeRZwyNDyMvz45+N8RdO78NV4LitqkjyesAQPm
         YPt/4xcXqTQ01sbFxGGEzizapKtRWy9y7kXSk=
In-Reply-To: <1299156472-4707-1-git-send-email-dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

---
 man/chcp.8    |    8 +++++---
 man/dumpseg.8 |   14 +++++++-------
 man/lscp.1    |    8 ++++----
 man/lssu.1    |   10 +++++-----
 man/mkcp.8    |    8 ++++----
 man/rmcp.8    |   10 +++++-----
 6 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/man/chcp.8 b/man/chcp.8
index 7f50784..d0b795a 100644
--- a/man/chcp.8
+++ b/man/chcp.8
@@ -6,11 +6,12 @@
 chcp \- change mode of NILFS2 checkpoints
 .SH SYNOPSIS
 .B chcp
-[\fIoptions\fP] \fBcp\fP | \fBss\fP [\fIdevice\fP] \fIcheckpoint-number\fP ...
+[\fIoptions\fP] \fBcp\fP | \fBss\fP [\fIdevice\fP | \fImountpoint\fP]
+\fIcheckpoint-number\fP ...
 .SH DESCRIPTION
 .B chcp
 is a utility to change the mode of the given checkpoints for the NILFS2
-file system found in \fIdevice\fP.
+file system found in \fIdevice\fP or mounted at \fImountpoint\fP.
 .B chcp
 changes checkpoints to snapshots, or vice versa.  The target
 checkpoints are specified with one or more checkpoint numbers.  When
@@ -18,7 +19,8 @@ checkpoints are specified with one or more checkpoint numbers.  When
 \fI/proc/mounts\fP.
 .PP
 This command is valid only for mounted NILFS2 file systems, and
-will fail if the \fIdevice\fP has no active mounts.
+will fail if the \fIdevice\fP has no active mounts and \fImountpoint\fP
+is not a mounted NILFS2 filesystem.
 .SH OPTIONS
 .TP
 \fB\-h\fR, \fB\-\-help\fR
diff --git a/man/dumpseg.8 b/man/dumpseg.8
index c0da6b5..8953dd9 100644
--- a/man/dumpseg.8
+++ b/man/dumpseg.8
@@ -9,16 +9,16 @@ dumpseg \- print segment information of NILFS2
 [\fB\-hV\fP]
 .sp
 .B dumpseg
-[\fIdevice\fP] \fIsegment-number\fP ...
+[\fIdevice\fP | \fImountpoint\fP] \fIsegment-number\fP ...
 .SH DESCRIPTION
 The
 .B dumpseg
-program is an analysis tool for on-disk logs of a NILFS2 file system
-found in \fIdevice\fP.  It displays the configuration of every log
-stored in the segments specified by one or more \fIsegment-numbers\fP.
-The term segment here means a contiguous lump of disk blocks giving an
-allocation unit of NILFS2 disk space.  When \fIdevice\fP is omitted,
-it tries to find an active NILFS2 file system from \fI/proc/mounts\fP.
+program is an analysis tool for on-disk logs of a NILFS2 file system found in
+\fIdevice\fP or mounted at \fImountpoint\fP. It displays the configuration of
+every log stored in the segments specified by one or more
+\fIsegment-numbers\fP. The term segment here means a contiguous lump of disk
+blocks giving an allocation unit of NILFS2 disk space. When \fIdevice\fP is
+omitted, it tries to find an active NILFS2 file system from \fI/proc/mounts\fP.
 .PP
 .B dumpseg
 is a tool for debugging rather than administration.  To list a summary
diff --git a/man/lscp.1 b/man/lscp.1
index b5a553b..7f302ac 100644
--- a/man/lscp.1
+++ b/man/lscp.1
@@ -6,12 +6,12 @@
 lscp \- list NILFS2 checkpoints
 .SH SYNOPSIS
 .B lscp
-[\fIoptions\fP] [\fIdevice\fP]
+[\fIoptions\fP] [\fIdevice\fP | \fImountpoint\fP]
 .SH DESCRIPTION
 .B lscp
-is a utility for displaying checkpoints or snapshots of the NILFS2
-file system found in \fIdevice\fP.  When \fIdevice\fP is omitted,
-\fI/proc/mounts\fP is examined to find a NILFS2 file system.
+is a utility for displaying checkpoints or snapshots of the NILFS2 file system
+found in \fIdevice\fP or mounted at \fImountpoint\fP.  When \fIdevice\fP is
+omitted, \fI/proc/mounts\fP is examined to find a NILFS2 file system.
 .PP
 This command will fail if the \fIdevice\fP has no active mounts of a
 NILFS2 file system.
diff --git a/man/lssu.1 b/man/lssu.1
index ec71158..6d51336 100644
--- a/man/lssu.1
+++ b/man/lssu.1
@@ -6,13 +6,13 @@
 lssu \- list usage state of NILFS2 segments
 .SH SYNOPSIS
 .B lssu
-[\fIoptions\fP] [\fIdevice\fP]
+[\fIoptions\fP] [\fIdevice\fP | \fImountpoint\fP]
 .SH DESCRIPTION
 .B lssu
-is a utility for displaying usage state of NILFS2 segments in
-\fIdevice\fP, where a segment is contiguous lump of disk blocks and
-an allocation unit of NILFS2 disk space.  When \fIdevice\fP is
-omitted, \fI/proc/mounts\fP is examined to find a NILFS2 file system.
+is a utility for displaying usage state of NILFS2 segments in \fIdevice\fP or
+mounted at \fImountpoint\fP, where a segment is contiguous lump of disk blocks
+and an allocation unit of NILFS2 disk space.  When \fIdevice\fP is omitted,
+\fI/proc/mounts\fP is examined to find a NILFS2 file system.
 .PP
 This command will fail if the \fIdevice\fP has no active mounts of a
 NILFS2 file system.
diff --git a/man/mkcp.8 b/man/mkcp.8
index 53b3a9e..fe6739c 100644
--- a/man/mkcp.8
+++ b/man/mkcp.8
@@ -6,12 +6,12 @@
 mkcp \- make a NILFS2 checkpoint
 .SH SYNOPSIS
 .B mkcp
-[\fIoptions\fP] [\fIdevice\fP]
+[\fIoptions\fP] [\fIdevice\fP | \fImountpoint\fP]
 .SH DESCRIPTION
 .B mkcp
-is a utility for making a checkpoint or snapshot for the NILFS2 file
-system found in \fIdevice\fP.  When \fIdevice\fP is omitted, it tries
-to find a NILFS2 file system from \fI/proc/mounts\fP.
+is a utility for making a checkpoint or snapshot for the NILFS2 file system
+found in \fIdevice\fP or mounted at \fImountpoint\fP.  When \fIdevice\fP is
+omitted, it tries to find a NILFS2 file system from \fI/proc/mounts\fP.
 .PP
 This command is valid only for mounted NILFS2 file systems, and
 will fail if the \fIdevice\fP has no active mounts.
diff --git a/man/rmcp.8 b/man/rmcp.8
index 11e5c07..05f7e56 100644
--- a/man/rmcp.8
+++ b/man/rmcp.8
@@ -6,13 +6,13 @@
 rmcp \- remove NILFS2 checkpoints
 .SH SYNOPSIS
 .B rmcp
-[\fIoptions\fP] [\fIdevice\fP] \fIcheckpoint-range\fP ...
+[\fIoptions\fP] [\fIdevice\fP | \fImountpoint\fP] \fIcheckpoint-range\fP ...
 .SH DESCRIPTION
 .B rmcp
-is a utility for removing checkpoints from the NILFS2 file system
-found in \fIdevice\fP.  The checkpoints which user wants to remove are
-specified with one or more \fIcheckpoint-ranges\fP.  When \fIdevice\fP
-is omitted, rmcp tries to find a NILFS2 file system from
+is a utility for removing checkpoints from the NILFS2 file system found in
+\fIdevice\fP or mounted at \fImountpoint\fP.  The checkpoints which user wants
+to remove are specified with one or more \fIcheckpoint-ranges\fP.  When
+\fIdevice\fP is omitted, rmcp tries to find a NILFS2 file system from
 \fI/proc/mounts\fP.
 .PP
 The \fIcheckpoint-range\fP must be provided with one or two integers
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
