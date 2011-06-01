From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Ability to discard all changes after a point in time?
Date: Wed, 1 Jun 2011 14:41:12 +0200
Message-ID: <201106011441.12465.dexen.devries@gmail.com>
References: <201105270828.32843.dexen.devries@gmail.com> <87hb89loja.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:references
         :in-reply-to:x-face:mime-version:content-type
         :content-transfer-encoding:message-id;
        bh=uHfFQvIcv1hgIsvPh63vO1jyFxBYhEb7Q9+67byVwY8=;
        b=ma2BtRKreaMsVB7xQni4vxuhxf6NOy9UInFsq3eKiz7FA1+RLzRVQoc/GXliGaIwFn
         1KYxjPi3kb+anp+P7ACCwDDTx4EHDpMSTYHJXokyOokPUCP8jBCTcEATSJASvKOEsEWF
         vkXMmheuJ2OYNDIYO0BskgRFuvhnPV8xXyWBE=
In-Reply-To: <87hb89loja.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Jiro,

On Wednesday 01 of June 2011 14:33:13 you wrote:
> I know this is not what you want, but as a partial solution,
> timebrowse (http://timebrowse.sourceforge.net/) can restore the files
> or directories of NILFS2 checkpoints from nautilus interface.
>=20
> Of course, this will merely rsync from the checkpoint to current moun=
t
> point. Therefore all the history still remain in the log and it may t=
ake
> unreasonable time if the differences are big.


Thanks, that's a good thing. Btw., is there any KIO slave or applicatio=
n for=20
KDE with similar functionality?

My target usecase was: OS is so mis-configured it won't even boot. I wa=
nted to=20
pass a parameter to kernel to make it discard some recent changes and g=
o on=20
with a slightly older version of files.

Another usecase was: due to bug in older kernel FS had a few recent=20
checkpoints corrupted. It's either back files up and re-format the file=
system,=20
or roll back a few minutes to an older, correct checkpoint.


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
