From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Is it possible to avoid nilfs2 corruption on power loss
Date: Tue, 15 Oct 2013 18:59:37 +0400
Message-ID: <101548A6-F56A-40DA-9820-864124267F7A@dubeyko.com>
References: <14aacfe4a690e434f9f49401ddd6c1be@znet.ca>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=odV/Fud6QY0QJEstCHh7NZWwrzTJh/7PDzIDCnvroto=;
	b=CSG45QsZoXrCmEAPa2H0O0zvUqyZHMcCwUblTfc1fk6uOw7ptANI+9NNouqHfGiWJLMERAewN3F5rzIxf8SOs1VqiLWii4qYvSd0YTv3wczS43Bdwib+REtFEMs+DFz+;
In-Reply-To: <14aacfe4a690e434f9f49401ddd6c1be-75tzoU7t5/k@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ggeorgiev-75tzoU7t5/k@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi George,

On Oct 8, 2013, at 6:57 AM, ggeorgiev-75tzoU7t5/k@public.gmane.org wrote:

> Hello everyone,
> 

Sorry for delay with answer. I were in business trip.

> I am in a situation where I need a way to make a practically incorruptible file system upon power loss. I know I can make this with a read-only fs + aufs + tmpfs, but it looks that nilfs2 may do this alone.
> 

I suppose that in real world we haven't any file system solution which can guarantee file
system's consistency for any situation. Always there are cases that can be resulted in
file system corruption even in the case of using very reliable solution. We live in not ideal world.

> Situation: I have few friends/clients whom I give a Raspberry Pi (RPi) with XBMC (actually, Xbian) for a home theatre. The RPi is powered by the TV USB port, and when the TV goes down, the PRi loses power. The /boot and / file systems are read only; that can be done. The /home however has to be writable - users may (rarely) change some configuration there. So, I put a nilfs2 there. The fs is ~7G on a 8G SSD card, full < 10% and almost no writes come ever.
> 
> What I need is the fs to never crash in such conditions. One idea to guarantee consistency is, I think, upon power on to mount an old checkpoint - say, 1-2 checkpoints back from the log end. It does not matter if the last written data is lost.
> 

If you need only in 1-2 checkpoints then one of the possible alternative can be F2FS too.
But as far as I can see, F2FS is not so stable and it has own drawbacks.

> I have no conclusive data, but my tests with random power pull-of show very good corruption resiliency up to now, but is there a way to guarantee that the file system will be truly incorruptible? Again, the use is very light and the SSD card partition will likely never fill.
> 

When you are talking about incorruptible file system then you need to take into account
several levels: (1) file system internal techniques; (2) block layer; (3) hardware layer.

Of course, NILFS2 has such very powerful concept as checkpoint/snapshot is based on
Copy-On-Write (COW) policy. Potentially it gives opportunity to rollback into previous
file system states. Also NILFS2's mount logic contains functionality of searching of last
valid checkpoint. But we haven't fsck utility for NILFS2. I suppose that NILFS2 doesn't
tested enough and it can contain undiscovered bugs yet. Such bugs can be resulted in
complete corruption of NILFS2 in some sophisticated situation. Moreover, as far as I can
judge, current realization of NILFS2 has such drawback. If you have real corruption of last
checkpoints and can't mount NILFS2's last state then you can't mount and snapshots also.
I really like NILFS2 but it needs to be honest about current code state.

There is research project "Reckon". This framework uses runtime checking to protect the
integrity of file-system metadata on disk. "Recon" performs consistency checks at commit
points in transaction-based file systems. So, this is a promising approach for guarantee
consistency on file system level.

You need to use data integrity extension (bio integrity) on the block layer for guarantee that
your data was really written on disk.

But, anyway, hardware can be a problem. I had situations where namely hardware (HDD drive)
was the reason of data loss (S.M.A.R.T reports about absence of any problem on the drive).
I suppose that RAID technologies can be a basis for reliable solution on hardware level.

So, anyway, all efforts in trying to guarantee truly incorruptible file system's state will be
resulted in significant performance degradation. Maybe, NVSRAM technology can be a basis
for approach that can provide combination of good throughput and reliability.

As a resume, I suppose that you need to have a compromise solution. Such solution can't
guarantee truly incorruptible file system's state but should provide good performance and
opportunity to recover file system state in target use-cases.

With the best regards,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
