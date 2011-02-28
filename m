From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: regression in 2.6.37?
Date: Mon, 28 Feb 2011 11:21:46 +0900 (JST)
Message-ID: <20110228.112146.55852337.ryusuke@osrg.net>
References: <87aahhuemz.wl%jir@sekiba.com>
	<8739n8vs1f.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8739n8vs1f.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 28 Feb 2011 10:58:36 +0900, Jiro SEKIBA wrote:
> 
> At Mon, 28 Feb 2011 10:33:24 +0900,
> Jiro SEKIBA wrote:
> > 
> > Hi,
> > 
> > I found that none of the checpoints are flagged 'i'.
> > It looks like it happens after 2.6.37.
> > 
> > So whenever I only execute "chcp ss <cp>" without any filesystem change,
> > nilfs volume create new cp without 'i'.
> > Before 2.6.37, it creates new cp with 'i'.
> 
> This, by the way, causes that nilfs2_ss_manager creates
> snapshots forever and useless as a result.
> 
> So I would really like to turn it back to the normal behavior.
> It is really critical for the application.
> 
> thanks
> 
> regards,

Arrh, that sounds so bad.  Ok, I'll look into the problem ASAP.

Ryusuke Konishi

> > It this somewhat new behavior or regression?
> > 
> > thanks,
> > 
> > regards
> > -- 
> > Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
