From: pg-9Cpm1x5jwYpury8xqvH7Ik8g8846gVy9@public.gmane.org (Peter Grandi)
Subject: Re: null pointer dereferenced with Ubuntu kernel 4.15
Date: Fri, 13 Mar 2020 18:57:05 +0000
Message-ID: <24171.55169.327616.643008@base.ty.sabi.co.uk>
References: <24166.20345.583274.370928@base.ty.sabi.co.uk>
        <20200309184240.GA14772@dropje.13thmonkey.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sabi.unospace.net; s=default; h=From:References:In-Reply-To:Subject:To:Date
        :Message-ID:Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dgBaw7d5ChDmyOuhZ9dexHK2X+tah/N3o86zmBB4rXo=; b=qQ7j80iFAFcEA19LutJTdaFYex
        omDwyXNzRULzHvrW1iH/3SGmlrwDDo2JFD12G6gWUvCaW/D3an/gVMS7eKqH5scuy6wmgsF7Wcz17
        7D3yBuh/xapEDMftyGD/cSJ36FqO0X9kix/nt8GJOSWnXmk4qP0XJglzptn9blBcYPKXf5RaJ7Jgg
        eIeJXV1gsswT10tfYtxcRGujI7FXqQ/bN8Dr7lu6ue0e9W0V0nuOhWnposovpazwLOxGv4uSteDHK
        3ZAkd6Kx4rzpzAkYLtjSm137KdwkMaTbg0v2HbxhVLhB90PwGfBtQeMcYpQ+y9jBlDEOVxDWcq7V5
        w 
In-Reply-To: <20200309184240.GA14772-WweU7nrmO3INqjISwOrxaLFspR4gePGN@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

>> Dear NILFSers I am perplexed because on upgrading my standard
>> Ubuntu LTS kernel "4.15.0-88-generic" I keep getting null
>> pointer dereferences as per attached kernel messages, and this
>> did not happen with the previous version "4.15.0-72-generic".

> I have these too, it looks like something in the linux kernel
> must hsve changed and tgey didn't test or looked for issues in
> the nilfs code.

That's my guess too, but it is a bit strange that it happens
between two minor versions of the same base kernel. But then
Debian and Ubuntu backport stuff to their kernels, so that's
probably why.

> It only starts here with writing on a previously written
> volume. A new volume works fine.

I have checked and that happens here too: if I recreated and
reload the volume no problems, but on the next reboot and mount
the problem reappears. I guess I'll try deleting the last
checkpoint to see if that helps, and/or looking at what changes
between the -72 and -88 versions of the 4.15.0 kernel if
anything seems related (there will be lots of changes I guess
though).
