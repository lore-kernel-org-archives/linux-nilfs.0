From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: newbie question
Date: Thu, 20 May 2010 18:18:33 -0400
Message-ID: <AANLkTinCEpf-iwHoD-mMELke4esF5cWDVG21AuMbBZZm@mail.gmail.com>
References: <4BF5A6E0.6040703@palm.com>
	 <AANLkTikeGWuCeGVELFipNnA_EQ-UHm4fbTvi6-qBiRBi@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:received:in-reply-to
         :references:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        bh=ME7mcRegF6sQ5ISyvrcbuOpxqUrKUayGV3vTlBIBE7w=;
        b=SR2GiP6QbcdWPN6y52p8hPI1aYdIIi9e6iGByo737111wULDOA6xMJd3J1R3t6Y0Zq
         0gmcbkwAFrna1ZFRAN/h2DDlDISMbwD6oaiHIPYwgcM1xK4a7zPoqQy1MaBLR332lCO/
         CeS2cKN15DU5mooiqwQrw1R7P8qTPqvjgTEXE=
In-Reply-To: <AANLkTikeGWuCeGVELFipNnA_EQ-UHm4fbTvi6-qBiRBi-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Sorry to say, but this is the first point in the TODO List:
Checkpoint rollback
See http://www.nilfs.org/en/current_status.html

However, I wonder if this has been worked on being the first point, I
guess it should not be hard to do, isn't that what NILFS does on boot
after an unclean shutdown?


On Thu, May 20, 2010 at 5:17 PM, Rich Pixley <rich.pixley-C65YXLrEp3M@public.gmane.org> wro=
te:
>
> Can nilfs "roll back" to a previous state of the file system?
>
> For example, at some time =3D T(N), I have a file system in a known g=
ood state. =A0So I check point it before taking a risky action. =A0Then=
 I take a risky action which leads me to the file system state at T(N+1=
).
>
> Sometimes, my risky action will be fine and I'll want to continue on.=
 =A0Other times, my risky action will result in a polluted, useless col=
lection of data which I would like to discard.
>
> I understand that at time T(N+1) nilfs will allow me to create a chec=
kpoint of T(N) which can be mounted read-only. =A0What I'm asking is if=
 nilfs can discard the state at T(N+1) and "roll back" to the state at =
T(N) as though T(N+1) had never happened.
>
> Can nilfs do this kind of "roll back"?
>
> --rich
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
