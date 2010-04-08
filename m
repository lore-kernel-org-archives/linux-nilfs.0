From: Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] nilfs2: add a print message after loading nilfs2
Date: Thu, 8 Apr 2010 13:45:05 +0800
Message-ID: <u2p3a3680031004072245t5ea476a5xbd6cbe6d3302de00@mail.gmail.com>
References: <20100405173402.GA22644@xhl> <20100405173534.GB22644@xhl>
	 <20100407142058.GA27224@xhl>
	 <20100408.113405.221629738.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:in-reply-to:references
         :date:received:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=jfHAs+s7DWboOrsYXYb3nc+Bf6UVrC5N2rvYCxh9bdY=;
        b=Zz9wqi9yVk6JdYL41qp2lJwtJ0g7rTaXJpok/VHOqdrdxZPz6y80+AqQaEoWhxcZmk
         ZRX8yHS5WHIAzIdvSfbfUHdBlmyJO3OF1Q17r/tnDe5eITIzYAIKszDt4lkd71rK23HN
         s6TCGYijF0Hqt2AU4wM8Lkgo2tMUZ96VUnB5Q=
In-Reply-To: <20100408.113405.221629738.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

2010/4/8 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>:
> On Wed, 7 Apr 2010 22:20:58 +0800, Li Hong <lihong.hi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
>> Hi KONISHI Ryusuke,
>>
>> Any feedbacks on these patches?
>>
>> Thanks,
>> Li Hong
>
> Well, adding a load message is ok, but it should be more moderate lik=
e
> "nilfs2 file system loaded\n".
Yes. I just thought that printing a message after loading a file
system is a practice.
You may choose any string that you think is suitable :)

> I think this sort of change should be discussed in the sub topic
> mailing list (i.e. linux-nilfs). =A0You don't have to cc every patch =
to
> linux-kernel.
Ok. No problem.

> And, please include some explanation in the change log to clarify the
> aim or motivation.
I took it as a very simple patch and thought a header was enough. I can=
 add more
explanations if here has a demand.

> Thanks,
> Ryusuke Konishi
>

Thanks very much,
Li Hong
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
