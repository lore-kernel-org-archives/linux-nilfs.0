From: "Carlos R. Mafra" <crmafra2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NILFS2 on an Intel X25-M SSD
Date: Sat, 2 Jan 2010 21:44:17 +0100
Message-ID: <20100102204417.GA6877@Pilar.aei.mpg.de>
References: <4B3A5D1F.9010002@gmail.com>
	<20091231.034629.85391956.ryusuke@osrg.net>
	<4B3C7326.4010002@gmail.com>
	<20100103.022425.52166650.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:date:from:to:cc:subject
	:message-id:references:mime-version:content-type:content-disposition
	:in-reply-to:user-agent;
	bh=NVRvRbFbzmNm/dT5bkrR6Kgx0V3eGCGxgxRfVIbiIiU=;
	b=WxylCi4Aciuf5eN3tEWlfXe5UMT/746VWaUO1m3d4Foj3l5fgGRSWK2XNa8JsLsxXP
	1morn16U523AGtV/OF7AFK3/8N0pofJvJnfab5cCDI7SvSC/H+1z7P0iC2K7tDjRVQDP
	yiRTzxbaks0WL1nDIe93Ynrk4WeJgimOYRfAc=
Content-Disposition: inline
In-Reply-To: <20100103.022425.52166650.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/options/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On So  3.Jan'10 at  2:24:25 +0900, Ryusuke Konishi wrote:
> On Thu, 31 Dec 2009 10:47:18 +0100, "Carlos R. Mafra" wrote:
>  
> > Naively I would think that the GC will always create some I/O that
> > other filesystems don't have, by its very definition. Can you
> > quantify by how much the current GC is writing in excess and what would
> > be the acceptable numbers?
> 
> The overhead is roughly measured as the number of copied (moved)
> blocks per reclaimed segment.  The following patch will print the
> ratio (number of copied blocks / cleaned blocks) into syslog.

Thanks for the reply and I will test your patch to see the numbers
in the following days.

> I don't know how much is acceptable, but at least, I think the GC
> frequency should be suppressed to 0 while the partition has enough
> free space, and the selection algorithm should be improved to give
> priority to free segments containing less in-use blocks.

Good that you mentioned it, because that is something I found a bit
unusual about NILFS2. 

Initially I copied 100 GB into the NILFS2 partition in the external
hard disk via a backup script using rsync. Then I deleted 10 GB from
my $HOME and reran the script to update the backup on the NILFS2
partition. The size reported by 'df' initially increased and I had
to wait around 10 hours to notice it decrease, but the decrease rate
was soo slow (around 100 MB/hour or so) that I did not wait anymore
and disconnected the hard disk. 

The partition has 150 GB, so perhaps NILFS2 thinks that there 
is "enough free space" and did not care too much about 
deleting the old data. But I thought that what would matter
most is the protection_period from /etc/nilfs_cleanerd.conf (3600)...

I must have understood it incorrectly, because I thought that after
3600 secs after deleting those 10 GB the partition would shrink to 90 GB
"quickly" (like in 1-2 hours). Than after those 1-2 hours my old
data would be forever gone.

So that was my odd feeling about NILFS2. I would not necessarily
say that it is a "problem" because if one is not using an external
hard disk then eventually there will be enough time to clean things
up, but it feels like it could be better. I have even read some
emails from the archives where people had problems with a full
partition even though they knew they had free space.

To test it a bit more, I increased nsegments_per_clean to 12, 
decreased protection_period to 60 and cleaning_interval to 2,
but now the cleanerd was using like 15% of CPU and it was not
cleaning the data much faster (I don't remember the numbers).

So what is more important to NILFS2, the notion of "free space
left" or the protection_period setting?
