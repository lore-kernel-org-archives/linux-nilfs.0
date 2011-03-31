From: "krzf83-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org " <krzf83-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: checkpoints to often
Date: Thu, 31 Mar 2011 21:19:27 +0200
Message-ID: <AANLkTinq052P2vvTfuTSuFgTWHKuZRyqDj=g2tFha0ZM@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:date:message-id:subject:from:to
         :content-type;
        bh=r+mHC0LpBLESl6MRoIGe8lyT6DzUZaXhawX6qGFHnws=;
        b=Su3lDoMLPRYo+hri0JxZUkL9SSVWTMJvrW//DF+Ot93ZMGZtISTIyVJQOpSzwi/kqa
         zvw/BN6ahnz8FPO9dcPN0pPs6f0lYN91fNoszLHqAu6qjOO+umy2cq7q4opsHteJgX+g
         3ekmePt+aLENngRLzkESFSrChdz3+c+ztATqo=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

There should be a way to make automatic checkpoints less frequent. On
the busy ssd I have about 7 cp every second. If it were for example
once every 5 minutes then one could set garbage removal every few
days.
Also garbage removal should have option to clean only if like 90% of
drive is used. there is no need to remove cp-s when there is still
many GB of space left.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
