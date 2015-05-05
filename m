From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 0/9] nilfs2: implementation of cost-benefit GC policy
Date: Tue, 05 May 2015 12:09:04 +0900 (JST)
Message-ID: <20150505.120904.106805384180179397.konishi.ryusuke@lab.ntt.co.jp>
References: <1430647522-14304-1-git-send-email-andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=Dp3dpfFGcUItqIhWxi9IC2QJ6IpMhDu1CcmvcoCBG8U=;
        b=oKK8NeorrF4TCjAScvX9D90LXhQTevIE3U3MttFSmeW4i5QC3laPJqn+Eey/BMBFRg
         AUGSI6Pjl8/RgSDvsInbddBSg2u7P1BtUH19MMVGO32JFc8BvdcFkxl50lVa1V7gmGLI
         hLMc9ZwH6UY82sU+sY6DGskPXotYqZKMbx/X0e7Pkn9xD7LVFfDBawySQRtXEkNB+lrX
         BkYryvyuKHijIrUdTgQ1mYZVZ7ZY05dnr4gPu4lv9XyWldUiFOMC1B4UZVbxdPOuv4Q1
         ft/smo11j4cvyt7u8sJvgQ9G8pUlYAhHlKHt5a9JOuC4BZCr1dLbVp0BDBZIZvHIpn7X
         p+pw==
In-Reply-To: <1430647522-14304-1-git-send-email-andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andreas,
On Sun,  3 May 2015 12:05:13 +0200, Andreas Rohner wrote:
> Hello,
> 
> This is an updated version based on the review of Ryusuke Konishi. It is
> a complete rewrite of the first version and the implementation is much 
> simpler and cleaner.
> 
> I include here a copy of my cover letter from the first version:
> 
> One of the biggest performance problems of NILFS is its
> inefficient Timestamp GC policy. This patch set introduces two new GC
> policies, namely Cost-Benefit and Greedy.
> 
> The Cost-Benefit policy is nothing new. It has been around for a long
> time with log-structured file systems [1]. But it relies on accurate
> information, about the number of live blocks in a segment. NILFS
> currently does not provide the necessary information. So this patch set
> extends the entries in the SUFILE to include a counter for the number of
> live blocks. This counter is decremented whenever a file is deleted or
> overwritten.
> 
> Except for some tricky parts, the counting of live blocks is quite
> trivial. The problem is snapshots. At any time, a checkpoint can be
> turned into a snapshot or vice versa. So blocks that are reclaimable at
> one point in time, are protected by a snapshot a moment later.
> 
> This patch set does not try to track snapshots at all. Instead it uses a
> heuristic approach to prevent the worst case scenario. The performance
> is still significantly better than timestamp for my benchmarks.
> 
> The worst case scenario is, the following:
> 
> 1. Segment 1 is written
> 2. Snapshot is created
> 3. GC tries to reclaim Segment 1, but all blocks are protected
>    by the Snapshot. The GC has to set the number of live blocks
>    to maximum to avoid reclaiming this Segment again in the near future.
> 4. Snapshot is deleted
> 5. Segment 1 is reclaimable, but its counter is so high, that the GC
>    will never try to reclaim it again.
> 
> To prevent this kind of starvation I use another field in the SUFILE
> entry, to store the number of blocks that are protected by a snapshot.
> This value is just a heuristic and it is usually set to 0. Only if the
> GC reclaims a segment, it is written to the SUFILE entry. The GC has to
> check for snapshots anyway, so we get this information for free. By
> storing this information in the SUFILE we can avoid starvation in the
> following way:
> 
> 1. Segment 1 is written
> 2. Snapshot is created
> 3. GC tries to reclaim Segment 1, but all blocks are protected
>    by the Snapshot. The GC has to set the number of live blocks
>    to maximum to avoid reclaiming this Segment again in the near future.
> 4. GC sets the number of snapshot blocks in Segment 1 in the SUFILE
>    entry
> 5. Snapshot is deleted
> 6. On Snapshot deletion we walk through every entry in the SUFILE and
>    reduce the number of live blocks to half, if the number of snapshot
>    blocks is bigger than half of the maximum.
> 7. Segment 1 is reclaimable and the number of live blocks entry is at
>    half the maximum. The GC will try to reclaim this segment as soon as
>    there are no other better choices.
> 
> BENCHMARKS:
> -----------
> 
> My benchmark is quite simple. It consists of a process, that replays
> real NFS traces at a faster speed. It thereby creates relatively
> realistic patterns of file creation and deletions. At the same time
> multiple snapshots are created and deleted in parallel. I use a 100GB
> partition of a Samsung SSD:
> 
> WITH SNAPSHOTS EVERY 5 MINUTES:
> --------------------------------------------------------------------
>                 Execution time       Wear (Data written to disk)
> Timestamp:      100%                 100%
> Cost-Benefit:   80%                  43%
> 
> NO SNAPSHOTS:
> ---------------------------------------------------------------------
>                 Execution time       Wear (Data written to disk)
> Timestamp:      100%                 100%
> Cost-Benefit:   70%                  45%
> 
> I plan on adding more benchmark results soon.
> 
> Best regards,
> Andreas Rohner

Thanks for your effort.

I'm now reviewing the kernel patches.  Please wait for a while.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
