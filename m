From: Hitoshi Mitake <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH nilfs-utils 0/2] trivial improvements of cleanerd
Date: Wed,  1 Jan 2014 16:30:47 +0900
Message-ID: <1388561449-13980-1-git-send-email-mitake.hitoshi@gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=yJUgUE+n/FR4ToT3dvXs0dB9bCVuF9A7XQNAk40ZgAE=;
        b=wnI4zEzzIBHSCcUpxjqqC3Fy87HA6aioBXSYg7H5G5MrhTgfFC1ZYwn8Tp0CldYGV9
         QT/2RboS+4IjnWZq5taQ6WoHToZTjJV9YuWjtxOkIr1OB3KbK+q3m+8YFf0i52K14lrc
         Bh06r/ZP4tDj4UjypDco+6MGlMNJylmU/cvhj4kcGc0mMiLQCiXbb0sS+FPsIvD7B8TZ
         0NyTzsqtDloFw4P+g9yT659ZG72G4jtI1PxskjtlaYI2vNqRm41REvNXviHdo1gqcrJP
         69O1lOciohlO6/2DP5dRMPwkRyLzpb4mIdTddR1n3jMfB0HMoqqf8q6IjqcrB5Zs1dio
         tItA==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

This patchset removes trivial problems in cleanerd. Below is a summary of the
problems:
1. current daemonize() of cleanerd doesn't ensure not to being a session leader
2. cleanerd doesn't adjust the OOM killer

Thanks,
Hitoshi

Hitoshi Mitake (2):
  cleanerd: call _exit(2) twice for ensuring not being a session leader
  cleanerd: adjust the OOM killer

 sbin/cleanerd/cleanerd.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
