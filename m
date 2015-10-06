From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 0/5] nilfs2: introduce tracepoints
Date: Wed,  7 Oct 2015 02:50:23 +0900
Message-ID: <1444153828-6747-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=OUa7NafZwS5Z+uatH6XCwVjZo37iIEd0pwDCCbKC0LU=;
        b=iSa+eYiqvw7e2FdwP0BJIfm4CHOzUcLKqGvfZNc2pwGJ+Sg6vmkL02e+UUkf+Z3o/9
         imsZMYoPRsWK+VdAMq32s30FgTchbjiEA3TS6cKogoqhHjH5bBHxpaHSY+E/n8JejdoC
         pvrAhdx9NUiJhGFsraFxLflDUHp7CMLzOWWejMdIQEISdV8izTBLzYoARrdchobvSfF3
         X1VYq8GBK4sYMnKHWas4dmABWkrp54MEHPDsO+k1tOAJaJRLROa7uoz2+vW/KO6Q2CkD
         8r9SS6Rl9mM1jWkfPoqHsNaloNaxnmxQuOq+bb4n2ySjElqoWei0ttZfFa40hASl+ba8
         b8ug==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi Andrew,

Please queue the following changes for the next merge window:

Hitoshi Mitake (4):
      nilfs2: add a tracepoint for tracking stage transition of segment construction
      nilfs2: add a tracepoint for transaction events
      nilfs2: add tracepoints for analyzing sufile manipulation
      nilfs2: add tracepoints for analyzing reading and writing metadata files

Ryusuke Konishi (1):
      MAINTAINERS: nilfs2: add header file for tracing

These introduces some tracepoints to nilfs2 to help tracking its
behavior for bottleneck detection, debugging, etc.

Thanks,
Ryusuke Konishi
--

 MAINTAINERS                   |   1 +
 fs/nilfs2/mdt.c               |   6 ++
 fs/nilfs2/segment.c           | 104 ++++++++++++++++----
 fs/nilfs2/segment.h           |   3 +-
 fs/nilfs2/sufile.c            |   8 ++
 include/trace/events/nilfs2.h | 224 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 324 insertions(+), 22 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
