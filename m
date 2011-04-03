From: Alessandro Salvatori <sandr8-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nilfs_cleanerd could use some sensible defaults if its conf file is empty...
Date: Sun, 3 Apr 2011 13:49:47 -0700
Message-ID: <BANLkTi=r2nmV1B9nF=f23fk2YxDch0ewRQ@mail.gmail.com>
Reply-To: sandr8-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:reply-to:from:date:message-id
         :subject:to:content-type:content-transfer-encoding;
        bh=ItSDdbKwaMOyOrqavBi7Dao+EAxMxMHRnAJXdUChhyk=;
        b=XndFOX0s+Flfb+2yFAeIRF/G/BwTRb6eLKfaScdT3tn2XU8zrtlx3SUQKeqMff/W+R
         x4DR+UjqZP1zxLT3OCIJcekyjeuDgyDy6ChE+GLm6Bi6QdKuWudGgF+eE1BrYNhBbjMb
         XLY9I79mD+lNkCQ4jtebwvmNVbA71yDqhTjIg=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

    my root nilfs2 filesystem filled and trying and editing
/etc/nilfs_cleanerd.conf resulted in an empty file.

I started the cleanerd but it wasn't freeing up any space.
Then I converted all of my snapshots back onto checkpoints and removed
all of my checkpoints.

still nothing.

Then I created a new nilfs_cleanerd.conf with sensible values in my
home directory and pointed nilfs_cleanerd to that.

and finally it worked!!!

maybe nilfs_cleanerd could default to some minimum of -say- the least
between some small amount of gigabytes and some small percentage of
the disk size as the minimum space to free if no setting is found in
the configuration file?

thank you!
-alessandro-
=A0Here i am, A young man,
=A0A crashing computer program,
=A0Here is a pen, write out my name.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
