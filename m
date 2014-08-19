From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Windows and Android drivers for nilfs
Date: Tue, 19 Aug 2014 10:02:48 +0900 (JST)
Message-ID: <20140819.100248.792475653630204223.konishi.ryusuke@lab.ntt.co.jp>
References: <B3F04BFA269AEF4E9CDC92FE83856C4C3A1A0DD7@USA-RWC-MBX-1.wipro.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=Lwknpb8H2pSdffkoH9bdtouK1WXRPvuK6/7pEh03y1Y=;
        b=mInHTqM8uqTU+2F/tLcomasHT2W1TalplzwP/lNuQqcJyAUT4oSI5hou/kJ2ROPY+i
         l+07PFJqL9OKC2cp8TwE817QdAI6DNUXJktOjEt4G+1pPQVFFeKI3E9ZHb66QOiKPGBB
         Y8ykGWDBXsWvsyFdR7MXhyJsBOweT11MeCBcdEvrYic/umk8+yJ62JwJ9QzjVjeu0wj7
         /4U5sXOR51RHwEu8m5V0YuXfyp+F+agiIV/Y5c1UqQIVrSTi1roq+L+zPFB3/vaZRc2V
         10/CLfWDuyrp+qF8Q+dDnqEy4sjzhIj/KX/0TQWEI8bwClOdQ0V88PXaf0Q6iyz+/GdQ
         xJgw==
In-Reply-To: <B3F04BFA269AEF4E9CDC92FE83856C4C3A1A0DD7-xEVdj5hl1ryABzCG+PzqMoJt+NpFC6AG@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dennis.murata-uxC5H9eHYlcAvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Tue, 19 Aug 2014 00:09:47 +0000, <dennis.murata-uxC5H9eHYlcAvxtiuMwx3w@public.gmane.org> wrote:
> Were there any plans to write Windows and Android drivers for
> nilfs2?  I did not see anything in the FAQ.  Android phones having
> large sdcards have to use fat{32,vfat} file system which is causing
> some problems.  It would be interesting if they could be formatted
> as nilfs or ext4 and still be read on Windows pcs.
> 
> Wayne

There is no windows driver of nilfs2 because the besement of driver is
completely different.  For Android, it may be possible to apply nilfs2
since Android uses the Linux kernel.  It seems that some trials
actually exist according to the result of search, however I don't know
for details.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
