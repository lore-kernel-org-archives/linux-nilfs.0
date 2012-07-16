From: shubham sharma <shubham20006-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: set_nilfs_init definition
Date: Mon, 16 Jul 2012 19:26:18 +0530
Message-ID: <CAGS5fSwzATDAj4wKr-gZF=s_3Fb429nnq9=w3Wgun-p77xn=+w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=FhMfVRZpZ2ahhEUhhBDusm9z3A1M3Ycex6xy2nqLj7c=;
        b=ObOLGntAzyoi2frX96OJZlHL8ckuc2oL3JbnQyDhfHxWUUb2JMNpP8QTzwVkhQ7eQ0
         bv47mZsO/3LLI33lf302C2TLJrsTyuD6B6XH0XMuYaCiRi4hvKcMtuh+EtGRq4r+h3C9
         ayI9Oismvd2S4XRu9rSboHg4rfno6VKuQVXA59+3sX9jJOV6Kgo26q4g6bOu72u5gvPG
         wMsqsPlTXGkusdguNhCX+A72lzitE6pFD2E66RQVQk+0SVqSJ4lunmsvgAdZehSdW1vY
         F2jlVarvRbLbUX03N5JTUVX5vbKQmssUhGB78mNy21tCLCaNipilF81Gcz2IUeoO2tYw
         L+Gw==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi All,

I was trying to understand the code of nilfs (kernel version 3.4.4)
and in the mount function i came across the function init_nilfs. In
this function there is a call to another function set_nilfs_init().
But i could not get the definition of the function. I wanted to know
where the definition of this function is present.

Regards,
Shubham
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
