From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: snapshots contain the same rrd database
Date: Wed, 26 Feb 2014 18:39:01 +0400
Message-ID: <1393425541.5481.25.camel@slavad-CELSIUS-H720>
References: <20140226133201.GA2022@wloczykij>
	 <1393422861.5481.9.camel@slavad-CELSIUS-H720>
	 <20140226142140.GD2022@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=9umVfgQLFrtR0qLbrnlR0kSNbTvQveO2Dp+YU9nb4QU=;
	b=oEBJPM/DHcziokcFokrGgaCEQC1CvkBTVjbAe/tiQv1tF8Sk5a9DzVPjFPCaw4tcXK+wVrSmp9+wzvMqpCDeOF+equFpgvRKnwsDMnys50B4pSMTSK+UXXdN+2HkTc0E;
In-Reply-To: <20140226142140.GD2022@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 2014-02-26 at 15:21 +0100, Piotr Szymaniak wrote:
> On Wed, Feb 26, 2014 at 05:54:21PM +0400, Vyacheslav Dubeyko wrote:
> > Hi Piotr,
> > 
> > On Wed, 2014-02-26 at 14:32 +0100, Piotr Szymaniak wrote:
> > > Hi,
> > > 
> > > I got a system crash after some 160+ days uptime. After a hard reboot I
> > > noticed my rrd database looks corrupted.
> > > 
> > > So I changed some recent checkpoints to snapshots, mounted them and...
> > > all the rrd files are the same!
> > > 
> > 
> > To be honest, I don't understand clearly:
> > (1) How did you get the issue?
> 
> To me it looks like the file hasn't changed since the first boot. Like
> it's not written at all? Is there a way to check something like "file
> position" on disk in specific snapshot?
> 
> rrds are a bit weird databases. When created they are, ie. size A. And
> all the way in time they gather some data and are always in that size A.
> The size doesn't change. Maybe this is related?

So, as far as I can judge, you can reproduce the issue stably. And you
suppose that file doesn't be written at all. How segctor and
nilfs-clenared threads behave itself as processes? Could you check that
they doesn't eat 100% of CPU?

If segctor is unable to flush data then it makes sense to use "echo t
> /proc/sysrq-trigger" for getting info about processes state. This
command outputs into system log usually.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
