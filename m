From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: ANNOUNCE: TimeBrowse 0.4 released
Date: Sun, 06 Mar 2011 01:34:06 +0900 (JST)
Message-ID: <20110306.013406.157464833.ryusuke@osrg.net>
References: <87oc5pd1k7.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87oc5pd1k7.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sun, 06 Mar 2011 00:33:44 +0900, Jiro SEKIBA wrote:
> Hi!
> 
> TimeBrowse v0.4 is released!
> http://sourceforge.net/projects/timebrowse/
> 
> This time, asynchronous history search is implemented.
> So it doesn't block nautilus even with vast amount of snapshots.
> 
> Changes are following.
> 
> TimeBrowse-v0.4  Sat Mar  5 21:39:41 JST 2011
>         * asynchronous history search
>         * add open in directory button
>         * change age calculation base
>         * calculate directory difference based on the directory entry mtime
> 
> nilfs2_ss_manager-v0.4  Sat Mar  5 21:39:41 JST 2011
>         * add clean option to cleanup remaining mount points (Ryusuke Konishi)
> 
> enjoy!

Thanks for the good work.

By the way, I feel the name of snapshot manager is a bit unimpressive.

How do you think of it?

Cheers,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
