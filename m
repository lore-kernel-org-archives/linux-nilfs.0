From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 5/5] MAINTAINERS: nilfs2: add header file for tracing
Date: Wed,  7 Oct 2015 02:50:28 +0900
Message-ID: <1444153828-6747-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1444153828-6747-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=f1xJQKCmBd2D5gMHAlbcJQmCLdbvkRUVLiptwrm6gro=;
        b=Dl4UIxHD6GP0rp7kYB/8JpheqPVL3fEwZw78P6D0HW+RVbodlqxAKGSaWQXQMxXzm7
         WWwhSDdciaN+FdgxXfcn1bVWlu0uGPUHT4zdsOiuTXA6JPhp3js5NEvRi4liOCLl1Jcl
         zSNkVW4EA/vb4sY0IdB5oKpgU/w/9xlmJiVXIv/+YnSCAfkrCCeCJX5P4qXSAfkFO1as
         eW1nl5AHa2iDXH7eRvyR7PMU7mbBs1xNTNOI5wy8F4x+/HRAeXH+a8gJy1qxUixLL8VM
         iemrY47uw4DRlbQrPYpYLjEAzwXLnxHSmdGDiaYsIAlrGYGZBh/M8Pn7rLAAjmFzZNs1
         NQ6g==
In-Reply-To: <1444153828-6747-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>, Steven Rostedt <rostedt@goodmis.org>, linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This adds header file "include/trace/events/nilfs2.h" to
maintainer-ship of nilfs2 so that updates to the nilfs2 header file go
to the mailing list of nilfs2.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 797236b..6b15b7a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7371,6 +7371,7 @@ S:	Supported
 F:	Documentation/filesystems/nilfs2.txt
 F:	fs/nilfs2/
 F:	include/linux/nilfs2_fs.h
+F:	include/trace/events/nilfs2.h
 
 NINJA SCSI-3 / NINJA SCSI-32Bi (16bit/CardBus) PCMCIA SCSI HOST ADAPTER DRIVER
 M:	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
-- 
1.8.3.1
