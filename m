From: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH nilfs-utils v2 0/4] rework daemonize() of cleanerd
Date: Mon,  6 Jan 2014 00:52:41 +0900
Message-ID: <1388937165-32692-1-git-send-email-mitake.hitoshi@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=viu+eU0CblpQ33qPDsPuZ45qSkFEmKtq6X4tFXNI5J8=;
        b=v9l//BqL/Pty+CoV2yNHR5ioSzjeBXzc94rw5jdrrSkI/d/OPX2qoDZV8GNPtIzs5p
         8D4Sb35gbz8VLRdQedPHnzdzsJNzaNl+OSOQuDUSBoO+cl0yZqRWa/SD3H4gIOk/L33e
         ODBtrvDj0IxhluLNUl4mfg9gy4jkKAhS15P1+FjDwlGROlvK3F6FDMtsfkwnYPK5BvvM
         3fCX3yS2PBh9sQ2oLUXwPN6pJkDrSUpsQpRQJ4gNznP6FUMwVwGgmIB3IzlU1tbW/y60
         NgNWRANMRAvddmEUG/Az+VLb/osRz3ZbgTM0RWBXB+GmWZu/OtJH3KksHxOqMcElmqoI
         sbGw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Current daemonize() function of cleanerd has a problem. It cannot ensure that
the caller (cleanerd) doesn't become a session leader.

This patchset solves the above problem. In addition, the -n option of cleanerd
is removed because it is obsolete. The description of the option in a man page
is also removed.

Hitoshi Mitake (4):
  cleanerd: ignore nofork option
  cleanerd: call _exit(2) twice for ensuring not being a session leader
  mount: don't pass -n option to cleanerd
  man: remove a description of -n option

 lib/cleaner_exec.c       |  4 +---
 man/nilfs_cleanerd.8     |  4 ----
 sbin/cleanerd/cleanerd.c | 36 ++++++++++++++++++++----------------
 3 files changed, 21 insertions(+), 23 deletions(-)

-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
