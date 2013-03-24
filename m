From: Martin Steigerwald <Martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>
Subject: Re: [PATCH] nilfs-utils: mkfs.nilfs2 should check presence of NILFS2 volume on device
Date: Sun, 24 Mar 2013 15:43:22 +0100
Message-ID: <201303241543.23310.Martin@lichtvoll.de>
References: <1364039122.16985.2.camel@slavad-ubuntu-12.04> <201303241309.19162.Martin@lichtvoll.de> <91A35B7F-A668-4B57-888F-7CE2A7D0ED86@dubeyko.com> (sfid-20130324_145707_596771_A57FD43C)
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <91A35B7F-A668-4B57-888F-7CE2A7D0ED86-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Am Sonntag, 24. M=E4rz 2013 schrieb Vyacheslav Dubeyko:
> Hi Martin,

Hi Vyacheslav, Eric and everyone else,

Eric, put you on Cc, cause you wrote mkfs.btrfs -f patch...

> On Mar 24, 2013, at 3:09 PM, Martin Steigerwald wrote:
> > Hi!
> >=20
> > Am Samstag, 23. M=E4rz 2013 schrieb Ryusuke Konishi:
> >> On Sat, 23 Mar 2013 15:45:22 +0400, Vyacheslav Dubeyko wrote:
> >>> From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> >>> Subject: [PATCH] nilfs-utils: mkfs.nilfs2 should check presence o=
f
> >>> NILFS2 volume on device
> >>>=20
> >>> The mkfs.nilfs2 utility should check presence of NILFS2 volume on
> >>> device and to warn a user about possibility to destroy data by mk=
fs
> >>> activity. This patch tries to read and to validate checksums of
> >>> primary and secondary superblocks on opened device. If this opera=
tion
> >>> ends successfully then mkfs.nilfs2 informs a user about potential
> >>> danger to destroy existing NILFS2 volume. The execution of
> >>> mkfs.nilfs2 stops with offering to make decision about continuati=
on
> >>> or abortion of operation. However, if a user runs mkfs.nilfs2 wit=
h
> >>> "-q" option then checking of NILFS2 volume is skipped.
> >>>=20
> >>> Reported-by: Hendrik Levsen <hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org>
> >>> Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> >>> Tested-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> >>=20
> >> This patch breaks compatibility of mkfs.nilfs2 in the case when us=
ers
> >> or tools are expecting overwrite an exisiting partition.  However,=
 I
> >> am inclined to accept this kind of protection feature.
> >>=20
> >> One thing disturbing is that "quiet option" is used to turn off th=
e
> >> protection; "quiet option" is just an option to suppress messages.
> >>=20
> >> Please consider adding "force overwrite (-f)" option like
> >> mkfs.xfs.
> >=20
> > Also please consider adding of other filesystems via blkid just as
> > mkfs.xfs and since a short time also mkfs.btrfs does.
>=20
> Sorry, I don't fully understand about mkfs.btrfs. Could you describe =
in
> more details what you mean?

mkfs.xfs was the first and to my knowledge long time the only mkfs whic=
h=20
checked for existing filesystems. And it does so via blkid (at least=20
meanwhile, I think it used different means initially). This way it dete=
cts=20
all current Linux filesystems without duplicating the detection code. b=
lkid=20
also detects nilfs:

merkaba:~> mkfs.nilfs2 -L test /dev/merkaba/zeit
mkfs.nilfs2 (nilfs-utils 2.1.4)
Start writing file system initial data to the device
       Blocksize:4096  Device:/dev/merkaba/zeit  Device Size:2147483648=
0
=46ile system initialization succeeded !!=20
merkaba:~> blkid /dev/merkaba/zeit
/dev/merkaba/zeit: LABEL=3D"test" UUID=3D"3a105634-638e-4288-8f39-0e532=
4361431"=20
TYPE=3D"nilfs2"=20

On some occasion the thought came up that it would be good to have a si=
milar=20
behavior in mkfs.btrfs. And mkfs.btrfs basically got a similar=20
implementation provided by Eric Sandeen. I digged it out, neither=20
ixquick.com nor Google found it out of the box and gmane search also di=
dn=B4t=20
yield a result. Thus manually browsed:

http://www.mail-archive.com/linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg22216.html

Ciao
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
