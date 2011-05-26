From: Dima Tisnek <dimaqq-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nilfs2 doesn't garbage collect checkpoints for me
Date: Thu, 26 May 2011 11:11:55 -0700
Message-ID: <BANLkTim4BBKwFJUzbnsKw0_Ru2k8ZW3MYw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:date:message-id:subject:from:to
         :content-type;
        bh=gggtvi5vLvU9lezoLIMlWd+u1pEIZVCnkP+S7gDFdjk=;
        b=J736uk+QzePwpCkJ3+Xo37MJvqeqK9zXQ2wk6+AgPGWhl8LQvPrJ+JqGC5ZBerQlyf
         TY7y1hUK6FS01Kd4GiKSkEooDTSW0C5pwy7hKuyxi3dcZ952qKp6/OSOOuInE6fm8+ut
         mSYjW/l2GaVGi+xzoGfOxEw5SHfrkSUuzlIzM=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I'm testing nilfs2 and other fs's for use on cheap flash cards, trying
to avoid writing same location all the time.
My test program makes lots of small sqlite transactions which sqlite
syncs to disk.
In less than 2000 transaction 1GB nilfs2 volume ran out of disk space.
tried unmount, mount again, didn't help
block device is nbd, works with with other fs's

lscp shows there are 7121 checkpoints and somehow old ones are not
removed automatically.
df -h shows 944M used 8M free 100% use
nilfs_cleanerd is running, its logs look ok (start, pause, resume,
shutdown, start, pause, resume)

kernel 2.6.38-arch
nilfs-utils 2.0.23

If someone interested I can drop the block device image to dropbox or something.

Thanks,
Dima Tisnek
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
