From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] nilfs-utils: mkfs.nilfs2 should check presence of NILFS2 volume on device
Date: Sun, 24 Mar 2013 19:08:42 +0300
Message-ID: <8C599058-8F00-4B0E-9BB0-D7F1DF34DC91@dubeyko.com>
References: <1364039122.16985.2.camel@slavad-ubuntu-12.04> <201303241309.19162.Martin@lichtvoll.de> <91A35B7F-A668-4B57-888F-7CE2A7D0ED86@dubeyko.com> (sfid-20130324_145707_596771_A57FD43C) <201303241543.23310.Martin@lichtvoll.de>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=Y77rD8SjdODCM9paYIHQcGGIHSo3BCuHAkAqrXVN6wk=;
	b=OB4ZhZm6mPmEcTEaWG+ZaOnN2Sr+hOCJs9RQlOLa9fcIT603GnoeuIJlO0/usHXl736o++Fma02UJMN9FvXNGvM6qSBHrCYsHvQKU4PlJKm7ZHaGqzX4/gqswN5ycP9A;
In-Reply-To: <201303241543.23310.Martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Martin Steigerwald <Martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hi Martin,

On Mar 24, 2013, at 5:43 PM, Martin Steigerwald wrote:
[snip]

>>=20
>=20
> mkfs.xfs was the first and to my knowledge long time the only mkfs wh=
ich=20
> checked for existing filesystems. And it does so via blkid (at least=20
> meanwhile, I think it used different means initially). This way it de=
tects=20
> all current Linux filesystems without duplicating the detection code.=
 blkid=20
> also detects nilfs:
>=20
> merkaba:~> mkfs.nilfs2 -L test /dev/merkaba/zeit
> mkfs.nilfs2 (nilfs-utils 2.1.4)
> Start writing file system initial data to the device
>       Blocksize:4096  Device:/dev/merkaba/zeit  Device Size:214748364=
80
> File system initialization succeeded !!=20
> merkaba:~> blkid /dev/merkaba/zeit
> /dev/merkaba/zeit: LABEL=3D"test" UUID=3D"3a105634-638e-4288-8f39-0e5=
324361431"=20
> TYPE=3D"nilfs2"=20
>=20
> On some occasion the thought came up that it would be good to have a =
similar=20
> behavior in mkfs.btrfs. And mkfs.btrfs basically got a similar=20
> implementation provided by Eric Sandeen. I digged it out, neither=20
> ixquick.com nor Google found it out of the box and gmane search also =
didn=B4t=20
> yield a result. Thus manually browsed:
>=20
> http://www.mail-archive.com/linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg22216.html
>=20

Thank you for detailed explanation and for the link.

Yes, using of libblkid is an excellent suggestion. As I see, it exists =
an example for mkfs utilities in libblkid library. So, I'll do it in th=
e way that you suggest.

Thanks,
Vyacheslav Dubeyko.

> Ciao
> --=20
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
