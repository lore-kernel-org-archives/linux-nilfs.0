From: pg-9Cpm1x5jwYpury8xqvH7Ik8g8846gVy9@public.gmane.org (Peter Grandi)
Subject: Re: NILFS error after power loss
Date: Mon, 31 Jul 2017 14:20:23 +0100
Message-ID: <22911.11927.173544.716094@tree.ty.sabi.co.uk>
References: <3909a3843e9fc28c7c1f7812f47b7b2b@fripost.org>
        <39eaa9df1d7d61fbcbfba585f26896e5@fripost.org>
        <22891.60687.912893.618455@tree.ty.sabi.co.uk>
        <78546a7101d18887029883c515fadbf5@fripost.org>
        <22899.28049.793418.168521@tree.ty.sabi.co.uk>
        <6603e34b36ee6db3997c47e450fc28dd@fripost.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6603e34b36ee6db3997c47e450fc28dd-m2T68/X/qvZAfugRpC6u6w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

[ ... ]

> But as far as I understand it is not possible to mount a
> previous snapshot as writable if there are snapshots/checkpoints
> after this snapshot. Since I only get a filesystem error when
> mounting a snapshot writable,

That seems unlikely to me. After mounting read-only, check whether
the whole filetree can be accessed error-free, with something like

  find $DIR -xdev -perm /07777 | wc -l

for metadata and then for data too:

  tar -f /dev/zero -c --one $DIR

> I will then have to remove one checkpoint at a time from the end
> and make the latest one a snapshot and mount it rewritable. [
> ... ]

Eventually, if you can find a checkpoint/snapshot that is
error-free, you can delete any newer corrupted ones and mount that
one read-write. Ideally you would do a nice backup before doing
that.

If you cannot find any that is error-free, probably that was
either a grievous IO error (most likely lack of proper barriers)
or the consequences of that recently discovered bug, if you are
very unlucky.

Usually the second newest checkpoint/snapshot is error-free when
a system crashes and the newest has got errors, that is usually
only the newest checkpoint is invalid.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
