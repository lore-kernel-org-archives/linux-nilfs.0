From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH v3 0/4] nilfs-utils: shortcut for certain GC operations
Date: Mon, 27 Jan 2014 17:35:58 +0100
Message-ID: <52E68AEE.2080900@gmx.net>
References: <cover.1390813175.git.andreas.rohner@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1390813175.git.andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-01-27 10:58, Andreas Rohner wrote:
> The benchmarks are currently running. I will give you the results
> shortly.

Here are the promised results:

I used a 100GB nilfs2 volume on both a HDD and a SDD and the well known
fs_mark benchmark tool. The benchmark consisted of the following steps:

1. Write a 20GB file (static data)
2. fs_mark -d dir -L 135 -D 16 -t 16 -n 150 -s 131072 -S 1 -w 4096
3. Wait for the cleaner to reach max_clean_segments

The following key configuration options were used:

min_clean_segments        20%
max_clean_segments        22%
nsegments_per_clean       4
mc_nsegments_per_clean    4
cleaning_interval         0.5
mc_cleaning_interval      0.5
min_reclaimable_blocks    5%
mc_min_reclaimable_blocks 1%
use_set_suinfo

HDD:
    Timestamp GB Written: 140.2588
    Timestamp GB Read:    48.06372
    Timestamp Runtime:    4145.151s
    Timestamp Disk Util.: 94%

    Patched GB Written:   120.1527
    Patched GB Read:      28.28576
    Patched Runtime:      3692.105s
    Patched Disk Util.:   93%

SSD:
    Timestamp GB Written: 210.2145
    Timestamp GB Read:    48.79246
    Timestamp Runtime:    3883.966s
    Timestamp Disk Util.: 87%

    Patched GB Written:   168.6009
    Patched GB Read:      28.66516
    Patched Runtime:      3566.425s
    Patched Disk Util.:   90%


The disk utilization is measured after step 2, because after step 3 it
is always 78%.

The results for the HDD show, that the 20 GB of static data were moved
in the case of the normal timestamp policy and they were ignored in case
of the patched timestamp policy.

The results for the SSD were similar, but the difference in GBs written
is 40 GB instead of 20 GB, which is a bit strange.

The value of 1% for mc_min_reclaimable_blocks seems to be ideal, because
it is just enough, so that completely full segments fall below the
threshold and can be skipped.

br,
Andreas Rohner

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
