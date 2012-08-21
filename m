From: Yury Shkandybin <jura-N6MIjFY6MsTQT0dZR+AlfA@public.gmane.org>
Subject: free space not reclaimed
Date: Tue, 21 Aug 2012 15:57:17 +0400
Message-ID: <0D65752F-DE69-4A4D-98B3-6C1FF5FE4039@netams.com>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:content-type:content-transfer-encoding:subject
         :message-id:date:to:mime-version:x-mailer;
        bh=yiLRjhMRxyOWMqat1ehbBB/M7Ko2aV9v9zx8+5rwmf4=;
        b=gU80SVYSagG2Mc92TdTdilxkTO2dMklp4zGErSlzzhQVLMa1lBBrnv98pBlNRg6krZ
         mmUFfDBxjG+db53+sH/0gkqCc9jbgUezsP9RhgouIidGzaLwNuHYDKSxXrXfQ8EVzBLG
         Hn4m29GpGIJ4trVeJV6eH5xg1hmHoDmkjhUDD0QXigmPPhY+f4nc9kmeNx3W+LRSEaTK
         LiqrTnwz1TmNKBW8mFdnh4TRjkUdULRSzTBgSfBWqB+0wibuqTreSOAKTc7IVASZCMrp
         iOwuf7dDXT6/R28j90aeka/dkut/AhUl0LKuLksFyk/HnXWU2bWrdp9n/9pHW4t2Sj2j
         CtsQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello.

Recently i overloaded my nilfs2 partition with data.
/dev/sda2        30T   29T  122G 100% /archive
I've removed 4T and issued:
rmcp -f 1.. 
nilfs-clean -p 0
, but used space left the same.
Actually it keeps increasing.

I've tried different versions nilfs-utils ( now sys-fs/nilfs-utils-2.1.4)
and kernels ( now sys-kernel/gentoo-sources-3.5.2)

nilfs_cleanerd  is running, keeping 1 LA
According to debug output, it keeps cleaning garbage segments, but number of clean segments stays the same:
Aug 21 15:42:38 WAYX017 nilfs_cleanerd[16907]: ncleansegs = 212114
Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: 4 segments selected to be cleaned
Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: segment 734108 cleaned
Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: segment 734109 cleaned
Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: segment 734110 cleaned
Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: segment 734111 cleaned
Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: adjust interval
Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: wait 0.000000
Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: wake up
Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: ncleansegs = 212114
Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: 4 segments selected to be cleaned
Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: segment 734112 cleaned
Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: segment 734113 cleaned
Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: segment 734114 cleaned
Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: segment 734115 cleaned
Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: adjust interval
Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: wait 0.000000
Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: wake up
Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: ncleansegs = 212114
Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: 4 segments selected to be cleaned
Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: segment 734116 cleaned
Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: segment 734117 cleaned
Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: segment 734118 cleaned
Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: segment 734119 cleaned
Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: adjust interval
Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: wait 0.000000

# cat /etc/nilfs_cleanerd.conf 
protection_period       3600
min_clean_segments      10%
max_clean_segments      20%
clean_check_interval    10
selection_policy        timestamp       # timestamp in ascend order
nsegments_per_clean     2
mc_nsegments_per_clean  4
cleaning_interval       5
mc_cleaning_interval    1
retry_interval          60
use_mmap
log_priority            debug


There was hard resets in the past with this server.
There is no snapshots.
Filesystem was created with -O block_count



Sincerely,
Yuriy Shkandybin




--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
