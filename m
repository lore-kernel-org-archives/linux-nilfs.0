From: Hendrik Levsen <hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org>
Subject: Re: couldn't mount because of unsupported optional features
 (477e7ad1e859f753)
Date: Fri, 31 Dec 2021 13:40:34 +0000
Message-ID: <726f32ef-5adc-d3d8-a926-a3a112f49ad1@levsen.org>
References: <39575f5e-b47a-d971-6c15-35985a35c9d5@levsen.org>
 <CAKFNMo=gkj_9wzw+qjmfHr53-4WZeMjSgwHnrDakfTdZkSGdNw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=smtp-gateway.net; s=dkim2k; h=Date:Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Message-ID:From:To:References:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=69CLJzY9ba09nXkleT2Tjvx94etr4TfFGr5y1EDAI0w=; b=lnv5PbVz682xl+2W42saqNESRe
        glEDRsMeBPS2xtXZiToZz+cApESDFQ0HMw/dfboQ6Z+ChmcjIE/aXIq6zrKmVB4tHuE16SMHWbrd4
        NFp77RyE/LXFIGsj9LW1/KrH4gsIjrHCrlzMGuN7ttObq/nXlBwNejdf5a5AeW4zvigeg+AWhdZUL
        8/HU4mRALLufJSbTXOpHAt+WdapDBkIbqBD4dDfFEzX2ZvgkEMbGHb8qRmK59GFOCT+OlYHeDEgqy
        rK1uJn97TuM313bHQKjCbS3vu5oJ0Af0pjOOdAMu8EnyROKJX8qjV7V/O77F8wDDC+uG63YZ9845Z
        UaF 
In-Reply-To: <CAKFNMo=gkj_9wzw+qjmfHr53-4WZeMjSgwHnrDakfTdZkSGdNw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-GB
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Peter and Ryusuke,

Awesome thanks for the detailed info and pointers. As for the risky
recovery attempts, presumably I can just copy the whole block device
block-by-block to a new disk or even a file and mess with it there to my
heart's content.

-- h.


