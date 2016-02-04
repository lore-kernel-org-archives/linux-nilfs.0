From: Eric Lan <tenoreamer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Feature request: a mount option or a config file to tell NILFS2 to
 make a checkpoint only when file overwriting/deletion occurs
Date: Fri, 5 Feb 2016 01:29:06 +0800
Message-ID: <CAFm8q6evbnqSwU78iOGtBoGyjy-Q-zENdEWs9DDedThQP+=Wkg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=KPjXAveV7dMaAMDgJ6aJHxFqyCi9+ReKTy2CT0mC5C0=;
        b=AhJrLZPCZCTU904sRaHU4pTz10aRmV2qqmkxq5oDxnhdEBe5tdHkhLm5ZK0QS5Lfz/
         YW90BxYV/4r4MculnKkG+VNttB7AYmXqNVVeF7cIiytPcKyLB5//Tv6hKeWNjcbhRFUe
         rF8a6tOiLHOp55lZiLgXrRg6Vvtuuo9rpvdetnSfOKiRBklGIlNICLQvyz70QR1iBWol
         N5qbHo0Xb3RzeEbQeW5c23aDUQ5IYFWdKDBYM4Fo2xtM6WhbJF0I6XVJ3eYtJmMfcDvo
         G+PUtNd9VIVuJEUy9twUdhmr4PjCMfc4/hpFKsMgJn1RBTyezZY1WtHEfSmds0VHiop8
         Wt5A==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

When I copy a 58G folder into a NILFS2 filesystem, 345 checkpoints are
automatically made for every 1-5 seconds. The folder contains just
some office files, pictures, movies and etc. I thought it unnecessary
to make these checkpoints. For a folder containing system states or
application states, the default NILFS2 settings of making checkpoints
are quite good. But for a folder such as mine described above, only
overwritting/deletion action is important and the overhead of making
checkpoints can be omitted to enhance filesystem performance.

I think the condition of making a checkpoint may be classified into
different levels, like:
Level 1: only overwriting and deletion triggers
Level 2: Level 1 + file creation
Level 3: Level 2 + modification of file metadata/attribution/owner/time etc
Level 4: Current default setting


Best regards,
Eric Lan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
