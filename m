From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Read/Access Timestamp?
Date: Tue, 24 Jan 2017 23:06:01 +0900 (JST)
Message-ID: <20170124.230601.1574047725550983985.konishi.ryusuke@lab.ntt.co.jp>
References: <trinity-c1b16ea0-3d14-4167-acfc-2d5f6c393a11-1485264632220@3capp-mailcom-bs10>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZNpfoTFmWFF/rWja8Gc+2PwvGkM0vvnYPVrnhR0DkvA=;
        b=H+MPC1lGkDknmydSuNZxAjoLbWXNQgTG8jKCqZApN9WHlBU9F6Yjwa8K4vHxLVeGLD
         b90vQo2xUP2sEA/NVnQq2DgkoN0jMXhplbuVBGC4vCh10x4dKNuHvDHSAgz1DjkCVn77
         PE4r/zBv3sxNnvVhsJmlGF82919lajOsqHztvOqhfw/vfnVNyp0vbmNwtlW5G3wSodwd
         26/oMZlpg2QD41G0581MdL64p8bbmHOHA5eLIc/4+KrYgVpyAwe5qpEz3SThKLj9PIYp
         aY3IkpSsjZO2eJq3DqY45xvvm5OZNDESKp9iLTTh6FBoVBkl4ffyfNetxLNGKVHxaNpU
         ZhUg==
In-Reply-To: <trinity-c1b16ea0-3d14-4167-acfc-2d5f6c393a11-1485264632220@3capp-mailcom-bs10>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: real34-W9aAOI/tHPE@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 24 Jan 2017 14:30:32 +0100, real34-W9aAOI/tHPE@public.gmane.org wrote:
> Hi
> 
> is there a last read/last access timestamp in nilfs2 ?

No, nilfs2 does not support access time.

It was addressed a future work, but still left unfulfilled for years,
sorry.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
