From: Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH tracepoints 0/2] refine coding style of the tracepoints branch
Date: Thu,  1 Jan 2015 20:44:22 +0900
Message-ID: <1420112664-509-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=G23Pwb8LjzxqCh0ukrDEXmuD8r/PjSpY4/b3Ch+PWnc=;
        b=MP2GgbT9/A890zSIatTrq72csFl7MCqgOW2fk8FgcJivG6D4mA+dSmxyPb/AQtOW9X
         PgWkfpo6KgGiO3m1McFdl1q44u/K6yAzNxtYqJrhW355/VngdUf1ZRvY7wiqDH/4scn6
         CvK/LBmriykqhYhgP3Xamr4yROnkqE6SWDMA/Sw8nI7ERhpGs12jl+Le7FZWqlodijEq
         VcwrsAvSucLeI4VtnXQmBjeHaegwEJ4qeTHNLs3Ub7o+KYgZ2ygfzK8vAxRRe+5noWiV
         ARGYFiN4/kKSRBcPMPEY+bZ2Qsjf/aagd07u1qbe7y9BezanBenTppOdOqYV5n+vwEII
         Py+A==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Hitoshi Mitake <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

This patchset refines the tracepoints branch of nilfs tree
(https://github.com/konis/nilfs2/tree/tracepoints).

The change unifies TP_printk() style. The new style doesn't put ','
between fields.

Ryusuke-san, could you replace the tracepoints branch with this
patchset?

Hitoshi Mitake (2):
  nilfs2: add a tracepoint for tracking stage transition of segment
    construction
  nilfs2: add a tracepoint for transaction events

 fs/nilfs2/segment.c           | 104 +++++++++++++++++++++++++++++++++---------
 fs/nilfs2/segment.h           |   3 +-
 include/trace/events/nilfs2.h | 103 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 188 insertions(+), 22 deletions(-)
 create mode 100644 include/trace/events/nilfs2.h

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
