From: Assaf Weizman <assaf.weizman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Super Root Block
Date: Mon, 8 Mar 2010 10:59:44 +0200
Message-ID: <63c84f241003080059v5f147ecas5b8df9ebc2d154aa@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:from:date:message-id
         :subject:to:content-type;
        bh=TFnMhS+hAQShObPTwR8o6R/KK972h6ieiiTOZsvsHfk=;
        b=kKCmUsLimeBHrijbV7eSG5LMFc5bxbsG1tpMsnwZaOquSK4utW475k48Zsu1C4flJP
         V71ZzqEuEAFpvKRgw/b6WxvUBI3rAShS76We25uh1dpMK0YC/kAsJieUsw/u/cYU/0eo
         6kq+BJCjqeC4GxLvxY2DhCrrN86iToZocawXk=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,
Could you please explain a few theoretical questions:
a. What's the meaning/usage of the "Super Root Block"?
b. in the Readme (v2) file it's described as "an optional super root
block (SR)". So as optional element,  who chooses to whether to
activate\use it or not?

Thanks a lot. this is a very interesting file system.

Best regards
Assaf Weizman
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
