From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 1/9] nilfs2: add /sys/fs/nilfs/features group
Date: Thu, 24 Apr 2014 10:41:55 +0400
Message-ID: <1398321715.2207.6.camel@slavad-CELSIUS-H720>
References: <1397837276.2178.52.camel@slavad-CELSIUS-H720>
	 <20140421.020501.511716674.konishi.ryusuke@lab.ntt.co.jp>
	 <1398151250.2181.13.camel@slavad-CELSIUS-H720>
	 <20140424.000949.330273957.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=3hsdmBa5m8n4EZTLr8yn/8iuncc+Cm5om2ojbTO77w0=;
	b=N/tfNKvHxfksuMXfBw6JtjSG9bby/GYcmXgkgccNND1F+osvNdxXa9PCIbLPN4q8vBtmlFRpDdRjvpGWOJCPGIWQow2jtOsZynW779nutbnnWoVXAhW3JEiqd1zW/Jjg;
In-Reply-To: <20140424.000949.330273957.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Ryusuke,

On Thu, 2014-04-24 at 00:09 +0900, Ryusuke Konishi wrote:

[snip]
> If we implement nilfs3 filesystem as a different instance like
> ext2/3/4 series, the namespace of nilfs/features/revision will
> conflict between nilfs2 and nilfs3.  In reality of course, creating
> nilfs3 is unlikely at present, but logically the above namespace
> design looks incoherent.
> 
> I now feel the namespace should be
> 
>   fs/nilfs2/xxxx
> 
> In this case, it doesn't cause the confliction regardless whether
> we add nilfs3 or not.
> 

Yes, you are right. Now I see the issue. I agree that we need to use
fs/nilfs2 namespace.

Anyway, we need to have group fs/nilfs2/features for showing features
that are supported by driver (for example, xattrs support and so on).
Likewise features support can be configured by Kconfig.

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
