From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: mkfs.nilfs2 -b 1024 -B 8192
Date: Thu, 14 Mar 2013 21:14:20 +0300
Message-ID: <424816AD-A79B-4F3D-A886-8D0CC735812B@dubeyko.com>
References: <20130313071453.GA17072@grill.lan>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=7Rnv/fB3IqY/Q0Hzu4L0YDWYK4Mv0DQW848jiJ5RFws=;
	b=FAz43IwR6cHphSyn0qgPANBfaMKK33o9I6eOQu3/KH/OHXaglxpSjYk+lYq+ijXnYTxDqERq6zkf0+5UZBwSLwk3D+UgVcxRXjnKEJn+XEazFXeREVzf6G6gPkwwlt/1;
In-Reply-To: <20130313071453.GA17072-P/DK4avwC2n/PtFMR13I2A@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Anthony,

On Mar 13, 2013, at 10:14 AM, Anthony Doggett wrote:

[snip]
> 
> Script:
>    VG=unencrypted
>    #apt-get install nilfs-tools darcs
>    lvcreate --size 2G --name ntest $VG
>    mkfs.nilfs2 -b 1024 -B 8192 /dev/mapper/$VG-ntest
>    mkdir /var/tmp/n
>    mkdir /var/tmp/n/ntest
>    mount /dev/mapper/$VG-ntest /var/tmp/n/ntest
>    mkdir /var/tmp/n/ntest/thedir
>    cd /var/tmp/n/ntest/thedir
>    sleep 2
>    date
>    darcs init
>    sleep 2
>    dmesg|tail -n 5
>    date
>    darcs whatsnew || true
>    date
>    sleep 2
>    dmesg|tail -n 5
> 
> (It's the "darcs whatsnew" that trips the issue.)
> 

I have reproduced the issue successfully. Thank you for the script and reproduction path description. I can investigate the issue now. But I suspect that it is 1 KB block size related issue because I can't reproduce the issue for 4 KB block size.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
