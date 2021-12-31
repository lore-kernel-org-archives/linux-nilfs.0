From: pg-9Cpm1x5jwYpury8xqvH7Ik8g8846gVy9@public.gmane.org (Peter Grandi)
Subject: Re: couldn't mount because of unsupported optional features
 (477e7ad1e859f753)
Date: Fri, 31 Dec 2021 11:55:17 +0000
Message-ID: <25038.61349.479758.553027@cyme.ty.sabi.co.uk>
References: <39575f5e-b47a-d971-6c15-35985a35c9d5@levsen.org>
        <25037.40801.808565.662504@cyme.ty.sabi.co.uk>
        <37be5d12-adea-6399-65c3-6d50008c18ff@levsen.org>
        <25038.60666.361700.270143@cyme.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=root.for.sabi.co.uk; s=dkim-00; h=From:References:In-Reply-To:Subject:To:
        Date:Message-ID:Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uH3vTVgjOmET+Jp6ze2MZw6Q8dc31sUJIfacxiNzRhc=; b=Zf3KX9fyXdBbCYCstLHa6JQnMN
        fxJIUBvEYXg59NZCRyIMDjoB0H2OKyK8sdAVuD/ajS8t94oIo2WMBJrlgZrP4LYlzEhS206Qgk6Zk
        5efZ4C5hFGaj6Dy0SPEoD3vhOwPrSqHIYbRYXJU4rJ9RARE7/JAmuSYHxCabMrcI9r6jkiOiOWhMl
        lW9OzBEt0ZGllY3nZ+MTvAqlCB3Z6KZSjiOnD4NPzmNXgI6R81pOw9TTHWNP42JAQvwfKS6S4fEZ2
        /kilYBwKQ3bpFND09fTq+/rZ1+kniHx0/dnzk+7axe8+3/YD/xz139TuBbXbJDfO9IaCX5ZucMiFE
In-Reply-To: <25038.60666.361700.270143-5EdyzN1Ji+RYO2OccljXW7VCufUGDwFn@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: list Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

>> This looks like a good idea, linear scan for segment nodes:
>> https://www.spinics.net/lists/linux-nilfs/msg02198.html Could
>> be the start of the fsck that never happened.

There was something like that:

  https://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01391.html

The same person has written a very detailed overview of the
implementation of NILFS2:

  http://dubeyko.com/development/FileSystems/NILFS/nilfs2-design.pdf
