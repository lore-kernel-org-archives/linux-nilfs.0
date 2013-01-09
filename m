From: Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: A lot of NILFS: bad btree node messages (readonly fs)
Date: Wed, 9 Jan 2013 14:20:52 +0800
Message-ID: <30D452FB-F1A5-425C-97ED-1A12CA4DCFD9@gmail.com>
References: <20121129210650.GA4028@wloczykij> <1354255744.2090.3.camel@slavad-ubuntu> <20121130073219.GB4028@wloczykij> <1356415552.2052.11.camel@slavad-ubuntu> <20130103214913.GE2080@wloczykij> <28ABE57F-66DD-491E-9FDB-A6CE3CF773FB@dubeyko.com> <20130104191633.GF2080@wloczykij> <C2F4A5DE-538B-4468-9A6A-BA619EDDA462@dubeyko.com> <20130105164752.GG2080@wloczykij> <504C0292-D0C6-426C-BDFD-1CD50FB32617@dubeyko.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:content-type:mime-version:subject:from:in-reply-to:date
         :cc:content-transfer-encoding:message-id:references:to:x-mailer;
        bh=gtK+B3Ch1/qguNimFVifFtWzzu3FmmVc3mlNjWqOUa0=;
        b=R2pBZJeDLKJoLzPq0JXjZDWoNsQBPIuGgqjOZtS6RBOmvNAHWlA/TG9gvFzxk+tb9r
         L+E3WPt/UvoKYHB5xlX+AXf7qbkcExCr02SZQHESmDKHAQXT+CaCz+K9Dg7o38fQ3tzI
         0P9PkO4JSeEBufxcPwjV9HpMacDvEwWa/nZZ2hpasdQ+mWKqLoUBsOZjYmAFwfTcSa+v
         yNssxUI3qOmMs4jTQTyVLU9BUL1Owalppv9HiC4MW6NZgoeyuIcHSITWtadVIkXgL+5x
         rH3FilAtKaz6uxcaCLAAXiteKXf5rXfzegbpd8vJ7WadPVbXPOESRp3Ptk6osYoazKIF
         kf+w==
In-Reply-To: <504C0292-D0C6-426C-BDFD-1CD50FB32617-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="gb2312"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>, =?GB2312?B?p7On1qfip9Sn1qfbIKehp92n1qfcp+On0affp9Wn4qfgp9M=?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


=D4=DA 2013-1-8=A3=AC20:52=A3=ACVyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> =
=D0=B4=B5=C0=A3=BA

> Hi guys,
>=20
> I am trying to reproduce the issue last three days but without succes=
s. I tried different workloads and different environments. As I know al=
l of you have the issue in reproduced state. So I have additional quest=
ions.
>=20
> 1. All of you have such messages:
>=20
> Jan 03 22:36:38 [kernel] [  953.289973] NILFS: bad btree node (blockn=
r=3D26229286): level =3D 67, flags =3D 0xee, nchildren =3D 40
> Jan 03 22:36:38 [kernel] [  953.289976] NILFS error (device sda2): ni=
lfs_bmap_lookup_contig: broken bmap (inode number=3D102230)
>=20
> As I understand, you still have message for concrete block number (fo=
r example, blocknr=3D26229286) during remount. But you haven't the mess=
age for this block number (for example, blocknr=3D26229286) after umoun=
t and mount again. But you can get error messages for another block num=
ber after it. Am I correct?

I got error messages for the same block after remount. That is to say t=
he bad block is always bad.

> 2. As I understand, you have corrupted file on your volume after such=
 error message (for example, for inode number=3D102230).
>=20

Yes. Once I open the corrupted file and read, kernel will report bad bt=
ree node and remount filesystem read-only.

> =D4=DA 2013-1-6=A3=AC12:46=A3=ACElmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =D0=
=B4=B5=C0=A3=BA
>=20
>> I have found the corrupted file using inode number:
>> [root@yf237 data0]# cat mysql6003/app_wyxgrab/weibo_rank.MYI > /dev/=
null=20
>> cat: mysql6003/app_wyxgrab/weibo_rank.MYI: Input/output error
>=20
> Could you share strace output for "cat" command for such corrupted fi=
le? Maybe syslog can contain some interesting details during execution =
of "cat" command. Could you check syslog for interesting error messages=
 during such try?
>=20

output of strace for cat: http://d.pr/n/Qboc
error messages during cat: http://d.pr/n/snOt

> 3. Could you share configuration file of your kernel (.config)? I sus=
pect that you can have some special configuration of your environment t=
hat I haven't.
>=20

content of /boot/config-2.6.32-220.13.1.el6.x86_64 : http://d.pr/n/qTQk

> 4. Could you share content of nilfs_cleanerd.conf file for NILFS2 par=
tition that has such issue? Sorry, if I ask about it again.
>=20

content of nilfs_cleanerd.conf: http://d.pr/n/YIwj

> 5. Did you have any sudden power-off before you encounter the issue f=
irstly?
>=20

No.

> 6. I understand that it can be not so easy. But, anyway, could you sh=
are details of your system log for the case of first case of the issue =
occurrence? I need only details about how live system before the issue.
>=20

I found some backtrace in syslog: http://d.pr/n/ddZd

> 7. I analyzed the raw dump of segment that I received from Elmer Zhan=
g. Currently, I have such feeling that it takes place situation when dr=
iver tries to take block that was filled by GC yet. But it needs to inv=
estigate the issue more deeply. And, currently, I don't understand how =
the issue can be achieved. Successful reproducing of the issue is a hal=
f of the success.
>=20
> Thanks,
> Vyacheslav Dubeyko.
>=20

---
Elmer Zhang

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
