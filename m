From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Cleancache
Date: Mon, 13 Jun 2011 15:21:15 +0200
Message-ID: <201106131521.15372.dexen.devries@gmail.com>
References: <201106081514.59693.dexen.devries@gmail.com> <20110608.230231.65968027.ryusuke@osrg.net> <20110613.221503.212701772.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=BIVuwvNhw9UdN9kKH2W8U3H06Akrcn2RDwWK0OMkd8I=;
        b=Pj2FxBuk68lmx4xSoZm0N1gc6v1zqyQYrwJHrahEMV3LelN2Cvc3sRPz6QyEWikC6V
         hMURJ2KNHDMbnMef7gCjMHHDpRzCIIRD2Gm3ugoe/Y9JlpxxrsNo1g2Jp4/5pUOnHE++
         X5CPLaR6U0EHuIygVGzbW22m1u3Fe5O/Xbc8E=
In-Reply-To: <20110613.221503.212701772.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,


On Monday 13 of June 2011 15:15:03 you wrote:
> I couldn't reproduce this problem.
> Could you tell me more about how you did it.
>=20
> May I reproduce the oops on native machines ? (I mean non-virtual
> machine environment).

I'll try to re-create the condition today; been busy through last weeke=
nd,=20
sorry~

It was on an 2-CPU SMP + SMT machine, raw hardware, if that makes any=20
difference; I'll see also if it gets triggered on VirtualBox.


Regards,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

=46or example, if the first thing in the file is:
   <?kzy irefvba=3D"1.0" rapbqvat=3D"ebg13"?>
an XML parser will recognize that the document is stored in the traditi=
onal=20
ROT13 encoding.

(( Joe English, http://www.flightlab.com/~joe/sgml/faq-not.txt ))
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
