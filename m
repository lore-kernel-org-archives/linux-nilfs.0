From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH tracepoints 0/2] refine coding style of the tracepoints
 branch
Date: Sun, 04 Jan 2015 12:39:01 +0900 (JST)
Message-ID: <20150104.123901.677735674841558505.konishi.ryusuke@lab.ntt.co.jp>
References: <1420112664-509-1-git-send-email-mitake.hitoshi@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=WTV3mXDJgpqSnA4/sLzq5jE/trcp0nNW4HUjyK/zioc=;
        b=w3n1l4N0gl8i1CbTo6xkI0g/TzkG+PH6iYQSj0usUegMitTHnLM9RW1kPmnLAMq9ck
         HPB0SSGsBD1sICevwJiNE8ZH29w93CPOHHvEbye/6oaGJd+QnhogmoH7GPS0Vb86VVdz
         Dxo80O7EuAsLkzYUTXZi+e5QQKNGFXaNdWzAxW1mzLivXLgw9ZBVQvzRxyCPQaz39RIH
         po0AE2j5vly8/go592aBq/TZYGyRz8DdGkpp+iy5laxL/w/BKNmxYSAWH3Rx7HY1Jyvx
         6OQ5sVUSZTjwPtlRnsmbZPEYKjmjnyV/vYpwcatisoGaf88aCbsUrTDXn6CYtG2EBx0t
         iI3Q==
In-Reply-To: <1420112664-509-1-git-send-email-mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Mitake Hitoshi <mitake.hitoshi-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitake Hitoshi <mitake.hitoshi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi,
On Thu,  1 Jan 2015 20:44:22 +0900, Mitake Hitoshi wrote:
> This patchset refines the tracepoints branch of nilfs tree
> (https://github.com/konis/nilfs2/tree/tracepoints).
> 
> The change unifies TP_printk() style. The new style doesn't put ','
> between fields.
> 
> Ryusuke-san, could you replace the tracepoints branch with this
> patchset?

I've just updated the branch.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
