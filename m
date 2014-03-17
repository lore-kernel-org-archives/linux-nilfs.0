From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 3/6] nilfs2: scan dat entries at snapshot
 creation/deletion time
Date: Mon, 17 Mar 2014 13:54:20 +0400
Message-ID: <1395050060.2205.22.camel@slavad-CELSIUS-H720>
References: <cover.1394966728.git.andreas.rohner@gmx.net>
	 <29dee92595249b713fff1e4903d5d76556926eec.1394966729.git.andreas.rohner@gmx.net>
	 <1395039845.2205.20.camel@slavad-CELSIUS-H720> <5326C1E5.10108@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=Bqtmpa55WwoV29Rm+sFf3y1GCyzD/cuaT8Bj5BIxHAY=;
	b=dpsbXGgoK7a2jQkoDsZKB22WLqIaaRDs8R5D9YZ1ipwAQApN+4UuruqcvLsBezFzapJkJKjf7wQIN+zksFxmtbQEt3uRl4IcBQq44ayRxH6MDVxuQKBZx88MIkVZ4+To;
In-Reply-To: <5326C1E5.10108-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 2014-03-17 at 10:35 +0100, Andreas Rohner wrote:

> >> +
> >> +	if (blocknr != 0 && end != NILFS_CNO_MAX && ss >= start && ss < end &&
> >> +			(prev_ss == 0 || prev_ss == NILFS_CNO_MAX)) {
> > 
> > Ditto. Moreover, you repeat this check.
> 
> What do you mean? Where do I repeat this check?
> 

I mean this check above:

>> +	if (blocknr != 0 && end != NILFS_CNO_MAX && ss >= start && ss < end) {

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
