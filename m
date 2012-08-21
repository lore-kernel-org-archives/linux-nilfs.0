From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: free space not reclaimed
Date: Tue, 21 Aug 2012 16:29:56 +0400
Message-ID: <1345552196.2457.52.camel@slavad-ubuntu-11>
References: <0D65752F-DE69-4A4D-98B3-6C1FF5FE4039@netams.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject; bh=syV2zo/7sA4JpwCS3imNCZ6BbIk1fkIAt+xyrjI8uIc=;
	b=L4cgsppbItQYOMLtLk8jKUYv+/IIAwJ++o2lZTzh+MtGUo/8C6XL8eLPmB9Z5hvlP1bZuq7fqckwn/W9YUnuB6Iouvi6/KaI06lc1lX1CBt6aWgqdzxTKMrkJ9QpU305;
In-Reply-To: <0D65752F-DE69-4A4D-98B3-6C1FF5FE4039-N6MIjFY6MsTQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yury Shkandybin <jura-N6MIjFY6MsTQT0dZR+AlfA@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Tue, 2012-08-21 at 15:57 +0400, Yury Shkandybin wrote:
> Hello.
> 
> Recently i overloaded my nilfs2 partition with data.
> /dev/sda2        30T   29T  122G 100% /archive
> I've removed 4T and issued:
> rmcp -f 1.. 
> nilfs-clean -p 0
> , but used space left the same.
> Actually it keeps increasing.
> 

Did you stop garbage collection or not? Could share status of cleaner
(nilfs-clean -l)?

Moreover, could you share output of the mount utility (without any
options, please)?

Could you share output of lscp and lssu utilities?

Do you have any errors messages related to NILFS in the system log?

Could you share trace of nilfs_cleanerd start?

With the best regards,
Vyacheslav Dubeyko.

> I've tried different versions nilfs-utils ( now sys-fs/nilfs-utils-2.1.4)
> and kernels ( now sys-kernel/gentoo-sources-3.5.2)
> 
> nilfs_cleanerd  is running, keeping 1 LA
> According to debug output, it keeps cleaning garbage segments, but number of clean segments stays the same:
> Aug 21 15:42:38 WAYX017 nilfs_cleanerd[16907]: ncleansegs = 212114
> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: 4 segments selected to be cleaned
> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: segment 734108 cleaned
> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: segment 734109 cleaned
> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: segment 734110 cleaned
> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: segment 734111 cleaned
> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: adjust interval
> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: wait 0.000000
> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: wake up
> Aug 21 15:42:39 WAYX017 nilfs_cleanerd[16907]: ncleansegs = 212114
> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: 4 segments selected to be cleaned
> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: segment 734112 cleaned
> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: segment 734113 cleaned
> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: segment 734114 cleaned
> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: segment 734115 cleaned
> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: adjust interval
> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: wait 0.000000
> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: wake up
> Aug 21 15:42:40 WAYX017 nilfs_cleanerd[16907]: ncleansegs = 212114
> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: 4 segments selected to be cleaned
> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: segment 734116 cleaned
> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: segment 734117 cleaned
> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: segment 734118 cleaned
> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: segment 734119 cleaned
> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: adjust interval
> Aug 21 15:42:41 WAYX017 nilfs_cleanerd[16907]: wait 0.000000
> 
> # cat /etc/nilfs_cleanerd.conf 
> protection_period       3600
> min_clean_segments      10%
> max_clean_segments      20%
> clean_check_interval    10
> selection_policy        timestamp       # timestamp in ascend order
> nsegments_per_clean     2
> mc_nsegments_per_clean  4
> cleaning_interval       5
> mc_cleaning_interval    1
> retry_interval          60
> use_mmap
> log_priority            debug
> 
> 
> There was hard resets in the past with this server.
> There is no snapshots.
> Filesystem was created with -O block_count
> 
> 
> 
> Sincerely,
> Yuriy Shkandybin
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
