From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] bin/*: improve error message on failure of nilfs_open()
Date: Sat, 23 Aug 2014 11:51:22 +0900
Message-ID: <1408762282-27273-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=99QVT3uato/0xHsvr8A9d9U4dJAAsF4N/Fh/CzKZKAg=;
        b=g/gYQcG4aIbXOK/sV3C3GND7Lep09i6AwjVi+rSxMdZ01GVz5jdcLkvXAEoa1t3aNb
         y3Q0dHp7JD0sUQGyzO9Ge20t6+xkuhLZN1/lJ2Tm0zsM9GyeHRzwRkh1vE58D5yjKwmi
         ENwMG9bJIJ/ltB2yhk7UlutvMfU88H9H8MJITU0xy48WXJkVzt1UEvu4/x/CKAPpSrJM
         O6DN/l/FckLHlfBEujL2N+PQ36AOURpnoEIaQl2spXLlid7ikSP2yCcQepXE1Zd0HMp6
         y+jx6H32ADS7Ksf/TNMRsh6i3NzDEONRMUyOYBfLCN7DL3uqO5M9AZjw5WVHNUtHqdtt
         gyhQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

The error message on failure of nilfs_open() function has two issues
in commands lscp, lssu, mkcp, chcp, rmcp, and dumpseg:

 1) When device name is omitted, a null pointer is passed to a string
    type field of the error message and a broken message is printed as
    below:

      lssu: (null): cannot open NILFS

 2) Description of errno is not shown in the error message.

This fixes these issues.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 bin/chcp.c    |    3 ++-
 bin/dumpseg.c |    3 ++-
 bin/lscp.c    |    4 ++--
 bin/lssu.c    |    4 ++--
 bin/mkcp.c    |    3 ++-
 bin/rmcp.c    |    3 ++-
 6 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/bin/chcp.c b/bin/chcp.c
index 837cf01..8596a14 100644
--- a/bin/chcp.c
+++ b/bin/chcp.c
@@ -139,7 +139,8 @@ int main(int argc, char *argv[])
 
 	nilfs = nilfs_open(dev, NULL, NILFS_OPEN_RDWR | NILFS_OPEN_GCLK);
 	if (nilfs == NULL) {
-		fprintf(stderr, "%s: %s: cannot open NILFS\n", progname, dev);
+		fprintf(stderr, "%s: cannot open NILFS on %s: %m\n",
+			progname, dev ? : "device");
 		exit(1);
 	}
 
diff --git a/bin/dumpseg.c b/bin/dumpseg.c
index 24a3624..0c138b2 100644
--- a/bin/dumpseg.c
+++ b/bin/dumpseg.c
@@ -218,7 +218,8 @@ int main(int argc, char *argv[])
 
 	nilfs = nilfs_open(dev, NULL, NILFS_OPEN_RAW);
 	if (nilfs == NULL) {
-		fprintf(stderr, "%s: %s: cannot open NILFS\n", progname, dev);
+		fprintf(stderr, "%s: cannot open NILFS on %s: %m\n",
+			progname, dev ? : "device");
 		exit(1);
 	}
 
diff --git a/bin/lscp.c b/bin/lscp.c
index 52447e5..2de81b6 100644
--- a/bin/lscp.c
+++ b/bin/lscp.c
@@ -401,8 +401,8 @@ int main(int argc, char *argv[])
 
 	nilfs = nilfs_open(dev, NULL, NILFS_OPEN_RDONLY);
 	if (nilfs == NULL) {
-		fprintf(stderr, "%s: %s: cannot open NILFS\n",
-			progname, dev);
+		fprintf(stderr, "%s: cannot open NILFS on %s: %m\n",
+			progname, dev ? : "device");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/bin/lssu.c b/bin/lssu.c
index ebbd926..09ed973 100644
--- a/bin/lssu.c
+++ b/bin/lssu.c
@@ -382,8 +382,8 @@ int main(int argc, char *argv[])
 
 	nilfs = nilfs_open(dev, NULL, open_flags);
 	if (nilfs == NULL) {
-		fprintf(stderr, "%s: %s: cannot open NILFS\n",
-			progname, dev);
+		fprintf(stderr, "%s: cannot open NILFS on %s: %m\n",
+			progname, dev ? : "device");
 		exit(1);
 	}
 
diff --git a/bin/mkcp.c b/bin/mkcp.c
index 57cf0c8..9dd6f0e 100644
--- a/bin/mkcp.c
+++ b/bin/mkcp.c
@@ -123,7 +123,8 @@ int main(int argc, char *argv[])
 
 	nilfs = nilfs_open(dev, NULL, NILFS_OPEN_RDWR | NILFS_OPEN_GCLK);
 	if (nilfs == NULL) {
-		fprintf(stderr, "%s: %s: cannot open NILFS\n", progname, dev);
+		fprintf(stderr, "%s: cannot open NILFS on %s: %m\n",
+			progname, dev ? : "device");
 		exit(1);
 	}
 
diff --git a/bin/rmcp.c b/bin/rmcp.c
index 92d672f..0943fe0 100644
--- a/bin/rmcp.c
+++ b/bin/rmcp.c
@@ -193,7 +193,8 @@ int main(int argc, char *argv[])
 
 	nilfs = nilfs_open(dev, NULL, NILFS_OPEN_RDWR);
 	if (nilfs == NULL) {
-		fprintf(stderr, "%s: %s: cannot open NILFS\n", progname, dev);
+		fprintf(stderr, "%s: cannot open NILFS on %s: %m\n",
+			progname, dev ? : "device");
 		exit(1);
 	}
 
-- 
1.7.9.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
