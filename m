From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Bug with future timestamp
Date: Thu, 16 Jun 2016 00:22:55 +0900 (JST)
Message-ID: <20160616.002255.2137939331212666701.konishi.ryusuke@lab.ntt.co.jp>
References: <AM4PR07MB1443A58B1332FBF20D3ED835A0540@AM4PR07MB1443.eurprd07.prod.outlook.com>
	<CALJXSJpSYW6jpPWWMUQEkmWoGyNhKBB7jJ+mUBxrM6=8G6uPEA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=auA2JPq2pX1IedLLrLcGRqqMLq3Jcya2rJoRYGw6gXo=;
        b=wFzffxdhoy8jGZGC9YRxiz75/iFDavKV905hG+PfbXQFYW60Djax8G9QCDq1+piKLx
         MubpgZ8Ib61fYrW2RlZBqa74QIHIQdCehQsvSusM+Tve1eqFRO7CUVioJFoT881GFUiC
         KZBqF+xDih7ypVplCmd/3H/RzBOspFMY2wGvhy8kvkaZOFeroCVHGbuydlAl5BlGixu1
         Z2bANymZ2e1PFdm8l88XCNNk+BUe0Wf+UQ0vPjWtM6o8/BdYEThHnfAJ15zyTkPSBZWj
         d5VziWOQlnud7DL5HE0TuEdFmiAmwf1quL9ZQ0Rc3UzNsBa17HtdpmyTLi+ihzqxGlxl
         c+RA==
In-Reply-To: <CALJXSJpSYW6jpPWWMUQEkmWoGyNhKBB7jJ+mUBxrM6=8G6uPEA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?J=E9r=F4me?= Poulin <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michele Marcon <M.Marcon-wB/b/6WKJkjDzftRWevZcw@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Tue, 14 Jun 2016 20:54:32 -0400, J=E9r=F4me Poulin wrote:
> On Tue, Jun 14, 2016 at 10:54 AM, Michele Marcon
> <M.Marcon-wB/b/6WKJkjDzftRWevZcw@public.gmane.org> wrote:
>> When the garbage collector starts, it will notice that the checkpoin=
t "from the future" is protected and will not remove it.
>> The problem is that it will not remove subsequent checkpoints (but w=
ith timestamp that shouldn't be protected), and therefore there won't b=
e any garbage collection until 2020.
>>
>> The only workaround is to manually remove the "future" checkpoints w=
ith rmcp.
>>
>> Is this a known issue? Thanks!
>=20
>=20
> I was bit by the opposite problem on my day to day laptop. I set my
> time in the past for some hours, then after restoring the correct
> time, the garbage collector destroyed all the checkpoints from the
> past. At this point, the FS was screwed. I reported the issue and
> can't find the patch that fixed it but I guess this is the kind of
> protection to be expected from my issue, checkpoints from the future
> can't be cleaned up.
>=20
> Pseudo-References:
> http://www.spinics.net/lists/linux-nilfs/msg00592.html

Do you mean an fs curruption occurs (even now) after the above rewindin=
g ?

If you mean all checkpoints looks to be removed, could you try "-a"
option of the lscp command ?

Regards,
Ryusuke Konishi

> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
