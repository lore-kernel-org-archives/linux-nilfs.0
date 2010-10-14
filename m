From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: production ready?
Date: Thu, 14 Oct 2010 08:25:20 -0400
Message-ID: <AANLkTi=hk=xSFLddi5+YOpZNPPDR7rO9Y+zF8N3+Wcdy@mail.gmail.com>
References: <AANLkTikL-wSkv4uTUM_g5Cs9=k3Q8TNkWXa0KNtnutXJ@mail.gmail.com>
	<20101014.145018.209367253.ryusuke@osrg.net>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:received:in-reply-to
         :references:date:message-id:subject:from:to:cc:content-type;
        bh=XeMSfrF+pV3vERNaaZR7PuNqV9QVM0kJNCCYuBacnqQ=;
        b=YJgiKUwQnJUnVw9S47dKiYKOTsuKvaLcOZCrRWVA4IkmGTUoiM9CeBALh4Zk+GyYll
         kbl2GGA43R5qtUL+WZP1+Vz8A35JgxtZ1AczXnoI5zX3k2akS41FTzHSSk02VtKziyon
         0Yr+iP3E/4GNpq/rINMDvEgLG6uSfZcYCpc3k=
In-Reply-To: <20101014.145018.209367253.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dschauer <dschauer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

On Thu, Oct 14, 2010 at 1:50 AM, Ryusuke Konishi
<konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> Hi,
...
> NILFS2 is almost stable.  We have a record of nine months operation on
> in-house samba servers and a webDAV server.
>
> On Wed, 13 Oct 2010 12:14:46 -0500, Dwight Schauer wrote:
>> Hello NILFS2 users and developers,
>>
>> How stable do you consider NILFS2? Performance issues aside, I'm more
>> concerned about reliability.
>>

On my side, it is on my laptop /home partition for a bit more than a
year, first month had corruption because of a bug which was fixed,
then a 2 months later corruption caused by garbage collector not
acting correctly when date is adjusted backward (in fact, forward then
backward in my case). But now it is corruption free and I can see it
when making a backup, no more I/O errors! Had some partition full
problems because garbage collector wouldn't start doing it's job until
I restarted it, but else it's OK.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
