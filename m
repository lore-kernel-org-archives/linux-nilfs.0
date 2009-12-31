From: "Carlos R. Mafra" <crmafra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NILFS2 on an Intel X25-M SSD
Date: Thu, 31 Dec 2009 10:47:18 +0100
Message-ID: <4B3C7326.4010002@gmail.com>
References: <4B3A5D1F.9010002@gmail.com>
	<20091231.034629.85391956.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:message-id:date:from
	:user-agent:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding;
	bh=go5bo1QxGVTonyVPH21Y4WLQFzpmPXgJWyD60m3aS7Y=;
	b=bZAZvsAnzYIn0cHXRldxCtaWLaZPa5HqXSbrR3nVytRDuaUQOoX7kIy3INPlU83PN8
	zQI7aMBgonbH3BjzpyAq89m88mvX8t5faF9QbmNuvF6eaiRnj7nlhPsjMzTuEcJbYUIc
	CNWRV81jFIZM6uybst5Ky9dfUzNvXfPrfCi5M=
In-Reply-To: <20091231.034629.85391956.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

Am 30.12.2009 19:46, schrieb Ryusuke Konishi:
> On Tue, 29 Dec 2009 20:48:47 +0100, "Carlos R. Mafra" wrote:
>> Is there any specific tweak in NILFS2 to use with an SSD? Would you
>> reccomend using NILFS2 on a SSD right now?
>>
>> Is the issue mentioned here
>>
>> https://www.nilfs.org/pipermail/users/2009-March/000514.html
>>
>> about excessive writing in the GC already fixed?
>> That is the most pressing fear I have about NILFS2 for the SSD.
> 
> Not yet, sorry.  I'm working on some performance optimization for high
> speed drives espacially for SSD.  Revising GC is another priority, but
> it would need some time.
> 
> The massive I/O by the current garbage collector may shorten the life
> of SSD.  So, I don't recommend yet.

Hmm, then I won't use NILFS2 on the SSD for now.

I am testing it in an external HD for the last two days to get a feeling,
and so far everything looks good and stable. It is a pity that the 
massive I/O problem kind of prevents putting it on the SSD.

Naively I would think that the GC will always create some I/O that
other filesystems don't have, by its very definition. Can you
quantify by how much the current GC is writing in excess and what would
be the acceptable numbers?

> If you are not interested in snapshots, I think nilfs is not always a
> good choice because high-end SSD drives are already doing lfs like
> optimization internally.  Intel SSD exactly looks like this sort of
> drives though I'm using nilfs on X25-M and X25-E ;)

The log-structured nature of the file system seemed a good thing for
the health of the SSD, yes. But the snapshot feature is something
interesting to have too and I was willing to have it :-)
