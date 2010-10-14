From: Dwight Schauer <dschauer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: production ready?
Date: Thu, 14 Oct 2010 07:55:44 -0500
Message-ID: <AANLkTik7tjKVBrJ_P83sitOVzeGk70AQCJF_CrwG6hYU@mail.gmail.com>
References: <AANLkTikL-wSkv4uTUM_g5Cs9=k3Q8TNkWXa0KNtnutXJ@mail.gmail.com>
	<20101014.145018.209367253.ryusuke@osrg.net>
	<AANLkTi=hk=xSFLddi5+YOpZNPPDR7rO9Y+zF8N3+Wcdy@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:received:in-reply-to
         :references:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        bh=nTJVtVH5XxUwidvQztQuC+ibYIezB1Qg48T2A/zsDFY=;
        b=RSHLPUdBdwjVH+LSOWo1wB9bfXJfUUSUxuMbXpK86nrEA4Aj8sd2HYISylVK5qxMDx
         3AmaUxfsIstc5LMvaCHveBZLSJHv/dl7iwSoW8suDzPZk+T2DN6WMpTu3ClGnSb5K8Iu
         wKeGlqknsj5zOb6T6bzlYKQm71lho7a7oiUss=
In-Reply-To: <AANLkTi=hk=xSFLddi5+YOpZNPPDR7rO9Y+zF8N3+Wcdy-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Oct 14, 2010 at 7:25 AM, J=E9r=F4me Poulin <jeromepoulin@gmail.=
com> wrote:
> On my side, it is on my laptop /home partition for a bit more than a =
year...

On Thu, Oct 14, 2010 at 1:50 AM, Ryusuke Konishi
<konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> NILFS2 is almost stable.  We have a record of nine months operation o=
n
> in-house samba servers and a webDAV server.

OK, Thanks.

There is still still warning when mounting verbosely though:
  mount.nilfs2: WARNING! - The NILFS on-disk format may change at any t=
ime.
  mount.nilfs2: WARNING! - Do not place critical data on a NILFS filesy=
stem.

As per the first message, Is the on disk format expected to change any
time soon? In other words, what is the likelihood of my using NILFS
when 2.6.35.x, then having some future kernel upgrade render my NILFS
formatted filesystems un-mountable because the on-disk format changed?

I understand the disclaimer of the the second message.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
