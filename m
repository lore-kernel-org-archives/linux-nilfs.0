From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: cleaner: run one cleaning pass based on minimum free space
Date: Thu, 08 Apr 2010 14:12:18 +0900 (JST)
Message-ID: <20100408.141218.179775797.ryusuke@osrg.net>
References: <4BBB724D.6040207@prnet.org>
	<20100407.030446.52169610.ryusuke@osrg.net>
	<0f70f9c8a2d58971d6d6af5104c73066.squirrel@www.prnet.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0f70f9c8a2d58971d6d6af5104c73066.squirrel-YfwCgBv0H3oBXFe83j6qeQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Wed, 7 Apr 2010 12:39:39 +0200, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org wrote:
> Hi,
> 
> At the moment of submitting my cleaner patches, I didn't know if you would
> use the new behavior as default behavior or the old one therefore in
> documentation I had described that min_clean_segments = 0 would mean
> normal cleaner behavior. However as the new behavior is now used as
> default behavior, normal behavior might be confusing.

That's right.
 
> I am thinking about doing the following changes in documentation:
> 
> in nilfs_cleanerd.conf change
> 
> # Minium number of clean segments
> # 0  = normal cleaner behaviour
> # >0 = start cleaning if less segments are available
> min_clean_segments      10%
> 
> to
> 
> # Minimum number of clean segments
> #   0 = continuous cleaning
> # > 0 = pause cleaning until less segments are available
> min_clean_segments      10%
> 
> I just saw that I had a typo in the word minimum.
> 
> in nilfs_cleanerd.conf.8 change
> 
> .B min_clean_segments
> Specify the minimum number of clean segments. A value of 0 means
> normal cleaner operation. A value greater than 0 means pause cleaning
> until less than min_clean_segments are available.
> 
> to
> 
> .B min_clean_segments
> Specify the minimum number of clean segments. A value of 0 means
> continuous cleaning. A value greater than 0 means pause cleaning
> until less than min_clean_segments are available.
> 
> What do you think about it ?
> 
> If you want to change, will you do changes or should I send you a patch ?

Well, that change would be better.
Send me the patch, please?

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
