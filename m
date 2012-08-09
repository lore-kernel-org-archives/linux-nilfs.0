From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs2 not garbage collecting
Date: Thu, 09 Aug 2012 13:17:30 +0200
Message-ID: <2382169.a90FXUemaH@coil>
References: <CANku=ggohcWWoxE1x=XmfWpANKyWRTWb5p_aHh8LU6+utU4OPQ@mail.gmail.com> <3170A27E-46DD-4347-8F9B-FBF4BB4E0205@dubeyko.com> <CANku=gha48jamDmmK6CxVEypryXPniPcgJ3BYa7zYm1EDyYGEg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-face:user-agent:in-reply-to
         :references:mime-version:content-transfer-encoding:content-type;
        bh=ir/+Xvax7ys9rSK7fD5Gc95j0MLdymbgdEAiFfvjJwY=;
        b=ghFJwjNVDlwPQhEV229oGGVCWwITWtxHIbqnKgfSOBGWnliExTXzR+bCL50n/0OpTD
         TaOujbVUO1XSj40LlTMLUxBCMHIoT8myuVEZwb2BNPERraIuO3JN6yScTKQiMQROcEv1
         uQpQajAjGVB8khj3pXJ1Zsc/m2EWI8zYMxv1GvpVenRMVNKA8cO63KwYEVjoZiW1y3Z/
         RCK13CDZHIVVLSnkPYmnmczeSLNGpUvlL04GTV/xM8zmQV1Jkks3b8TBoU6kWmfFqSDp
         tgp9BJwIMAV4dWOPRtjWSMhGG93orr/YzDEctpiUAO7rZBM6c4pJyMIh6bPiOoLMSURj
         f7xw==
In-Reply-To: <CANku=gha48jamDmmK6CxVEypryXPniPcgJ3BYa7zYm1EDyYGEg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Paolo Giangrandi <paolo-UnihLHphgvQ1GQ1Ptb7lUw@public.gmane.org>

On Thursday 09 of August 2012 12:33:09 you wrote:
> I'm having some issues at uploading the compressed image (it's "just"
> 2.3GB, but with my current connection it would take days, I'll upload
> it on september).
>=20
> Meanwhile nilfs_cleanerd managed to free some more space (over 1GB),
> although nothing has changed since yesterday, thus everything seems
> back to normality.
> Thanks for the help and see you in september!


when i'm in a pinch and want cleanerd to free up some space, i run:
# while true; do killall -HUP nilfs_cleanerd; sleep 4; done

each `HUP' signal causes cleanerd to both re-read config and run single=
 pass.

i then monitor progress with
# iostat -dk 1 /dev/sda

to see if it is moving data around. if not, i lower `protection_period'=
 in=20
/etc/nilfs_cleanerd.conf; I usually have it set to 7 to 14 days on pers=
onal=20
computers, but when /really/ in a squeeze for free space, i lower it to=
 24h.

you may also want to increase `nsegments_per_clean' in nilfs_cleanerd.c=
onf to=20
3 (but not much more; each segment causes up to 8MB of read and write u=
pon=20
each cleanerd pass).


cheers,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
