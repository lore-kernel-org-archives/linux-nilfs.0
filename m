From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs_clean_segments: segment construction failed. (err=-2)
Date: Thu, 26 Jun 2014 09:35:00 +0400
Message-ID: <A863805F-8398-42B1-9BEA-35D4425E2404@dubeyko.com>
References: <53ABA8F3.3010606@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=Wxc+Joc4XGYQfeMUP4hogJ3ItfEIi9DAwLhkJ8C/CDo=;
	b=FtohAxk4RcZSMNfg4QLjtCpJUd5AeeNPcVcUq/PtlRGPYVXddHGuXkCRC+7fMJWfy4wqFNqPLFq7vppdhs0d+HR0rDJegvde+Eh49pSXwJapiuNyS8b4r89reATGydH5;
In-Reply-To: <53ABA8F3.3010606-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: dE <de.techno-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Jun 26, 2014, at 9:00 AM, dE wrote:

> Hi!
> 
> I'm using nilfs on thumb drives to sync Bitcoin wallets and it's forks.
> 
> Sometimes, when I quit the bitcoin-qt application, this is what happens (in dmesg)
> 
> [159141.505498] nilfs_btree_propagate: key = 10, level == 0
> [159141.715622] nilfs_btree_propagate: key = 10, level == 0
> [159141.716134] NILFS warning (device dm-0): nilfs_clean_segments: segment construction failed. (err=-2)
> [159146.715145] nilfs_btree_propagate: key = 10, level == 0
> [159146.715152] NILFS warning (device dm-0): nilfs_clean_segments: segment construction failed. (err=-2)
> [159151.715018] nilfs_btree_propagate: key = 10, level == 0
> [159151.715026] NILFS warning (device dm-0): nilfs_clean_segments: segment construction failed. (err=-2)
> [159156.714892] nilfs_btree_propagate: key = 10, level == 0
> ...
> ...
> ...
> [160276.691089] nilfs_btree_propagate: key = 10, level == 0
> [160276.691096] NILFS warning (device dm-0): nilfs_clean_segments: segment construction failed. (err=-2)
> [160281.690959] nilfs_btree_propagate: key = 10, level == 0
> [160281.690967] NILFS warning (device dm-0): nilfs_clean_segments: segment construction failed. (err=-2)
> 

What kernel version do you use?
What garbage collection policy do you use?
Could you share superblock content (nilfs-tune -l)?

> I can still access the thumbdrive and it's contents. In the mean time many processes remain at D state and I have to force restart.
> 

So, could you describe clear way of the issue reproducing on my side?

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
