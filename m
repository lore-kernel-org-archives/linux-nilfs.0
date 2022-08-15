From: John Haxby <john.haxby-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [vs-plain] KASAN: use-after-free in nilfs_mdt_destroy
Date: Mon, 15 Aug 2022 15:09:05 +0000
Message-ID: <8C0C088A-11A4-4D0E-93B9-CA70F0040341@oracle.com>
References: <34e8df4a.848e1.182a1264256.Coremail.stitch@zju.edu.cn>
Mime-Version: 1.0
Content-Type: multipart/signed;
        boundary="Apple-Mail=_1F410261-EFD2-4EED-B98D-AF6A4C46935E";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=NB4wxJFHXGSD3l6NCcipCQ2XF1sJcWRCBanSROT8VKE=;
 b=q4d8FO67JBCYNK2F5LvK4s+mJp5/HBWXpcSZVxIb9P/5upZvD4ZFP83QNBSAh9G+wUpm
 UhcbqbP76nZuE1Y0tcGqaxbg5TJSC0o8Vf0gwRJw/mQohs65SqtJ9EZ4r0Vt9OhATU88
 GKijZ/uTYOuq6XZuZyKJA/8MDK2XQnMA6n60Cz/h4rcocPOqbQ8Zwhx2RR+kPJLC3CC5
 ZGUyO2J6xRa+UIkASbZkW5aUTCT9SBdo8CZz3jmt6ah9WyOlha6z95Ub4SVqt1UsSly1
 8cFfcxDIauHGI3KC+iitipJR/5UIqX4i31SZoUQdqhYtR98XAqnepk3yqS8QpIwWc9dI Vw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NB4wxJFHXGSD3l6NCcipCQ2XF1sJcWRCBanSROT8VKE=;
 b=HiE0TTcoJ/SWiLSmXpBEobI+mD5gNI51xstDXIAKPbX///VoQq2E7zk9eDCjRDP3UxMimTZrkuM25ayAARuDNgti2U+/+uzFF2iD64CvBm5xnlXCdWF8z038pF4ICrnflQGtEKJ/BtaCHrQda1qxhFZOMfPpioxC5eWQ6Mn9+4w=
In-Reply-To: <34e8df4a.848e1.182a1264256.Coremail.stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>
Content-Language: en-US
List-ID: <linux-nilfs.vger.kernel.org>
To: =?utf-8?B?6K645ZiJ6K+a?= <stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>
Cc: "security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-distros-DYwG1KUNWo0m4/wLoHy/Wg@public.gmane.org" <linux-distros-DYwG1KUNWo0m4/wLoHy/Wg@public.gmane.org>, "konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

--Apple-Mail=_1F410261-EFD2-4EED-B98D-AF6A4C46935E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On 15 Aug 2022, at 11:56, =E8=AE=B8=E5=98=89=E8=AF=9A =
<stitch-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org> wrote:
>=20
> Hi developers,
>=20
> We may found a flaw in the fs module which can lead to UAF write or =
DoS.
> We would appreciate a CVE ID if this is a security issue.
>=20

Confirming that your message made it through to linux-distros, but you =
haven't mentioned a date when this would be made public.  However,

> Someone found the similar problem: =
https://groups.google.com/g/syzkaller-bugs/c/z2WroC3_BSw.
>=20
> Fix this bug by moving the assignment of inode->i_private before =
security_inode_alloc.

There's already a public discussion about that and if, indeed, that's =
the same bug then you should take this to oss-security as simply a =
rediscovery of an existing bug.

I'll leave it to Red Hat to decide whether to allocate a CVE number for =
this issue. It needs significant privileges to exploit it; the only real =
question is whether you could use those privileges to crash the machine =
anyway.

jch

--Apple-Mail=_1F410261-EFD2-4EED-B98D-AF6A4C46935E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iHUEAREIAB0WIQT+pxvb11CFWUkNSOVFC7t+lC+jyAUCYvphkAAKCRBFC7t+lC+j
yLtZAQCp6LrHUxK+9ACDzogU9XE3HogPasFVmXwOqFgmyRehDwD+ONv3fT8yq6g7
ZyYQ/AZxxv3bfpDsyogZea4GJtWDgvw=
=/9pF
-----END PGP SIGNATURE-----

--Apple-Mail=_1F410261-EFD2-4EED-B98D-AF6A4C46935E--
