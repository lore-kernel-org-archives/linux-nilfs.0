From: pg-9Cpm1x5jwYpury8xqvH7Ik8g8846gVy9@public.gmane.org (Peter Grandi)
Subject: Re: NILFS error after power loss
Date: Sat, 22 Jul 2017 16:21:53 +0100
Message-ID: <22899.28049.793418.168521@tree.ty.sabi.co.uk>
References: <3909a3843e9fc28c7c1f7812f47b7b2b@fripost.org>
        <39eaa9df1d7d61fbcbfba585f26896e5@fripost.org>
        <22891.60687.912893.618455@tree.ty.sabi.co.uk>
        <78546a7101d18887029883c515fadbf5@fripost.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <78546a7101d18887029883c515fadbf5-m2T68/X/qvZAfugRpC6u6w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

>> The standard NILFS2 recovery is to mount an earlier
>> checkpoint. This to be done quickly to ensure they don't get
>> deleted by the cleaner, but then if the system does not start
>> it should not start either.

> I have started on Ubuntu Live and mounted the filesystem

That can be done with option 'nogc' to avoid garbage collection
of checkpoints.

> and have made the earliest checkpoint a snapshot in order not
> to lose it.

Good idea, would be nice perhaps also for other checkpoints.

> How do I rollback in the simplest way?

As the manual explains, checkpoints can be mounted, and if they
fail to be mounted, be deleted. The NILFS2 code tries to mount
the latest checkpoint (with a valid checksum).

>> Usually corruption like this is because of the storage system
>> not implementing correctly barriers, and that might related
>> to the use of DM (some versions lack that implementation). If
>> barriers do work the previous checkpoint to the faulty one
>> should always be correct, because it has been checkpointed.

> I do not know the technical details well enough. Where can I
> read more about what barriers mean in this context?

I think that there are things like "web search engines" that
might help, but to starts that search those means features of
hardware and software that ensure that all critical updates are
recorded on persistent storage, things used to implement "fsync"
and the in-kernel equivalent. Since you use a laptop you may
have been tempted to disable or weaken them.

> What does DM mean?

"Device Manager", as indicated by the error message including
"dm-0":

>> Apr 24 06:55:22 nixos kernel: NILFS (dm-0): bad btree node (ino=1609, blocknr=13626216): level = 51, flags = 0x44, nchildren = 12298

It is used to support LVM2 or LUKS etc.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
