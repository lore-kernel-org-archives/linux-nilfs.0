From: Mateusz Jan Przybylski <m.przybylski-HTS31/ZL/NClPcVs/6D9LQ@public.gmane.org>
Subject: Re: Ability to discard all changes after a point in time?
Date: Fri, 27 May 2011 09:44:51 +0200
Message-ID: <201105270944.52201.m.przybylski@bkfmyjnie.pl>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

On Friday 27 of May 2011 09:34:34 you wrote:
> The feature is indeed one of todo items, and I just have been
> considering the topic for upcoming LinuxCon Japan.
>=20
> At present, I made a patchset which can revert only one fully deleted
> regular file without duplicating data blocks. (This work derives your
> post titled "It is not possible to restore file from a mounted
> snapshot using a hardlink" and the successive reflink topic.)
>=20
>=20
> The challenge in the rollback (or revert) feature is to handle
> lifetime of each disk block, which is maintained for garbage
> collection.  (a disk address table, which we call DAT file, preserves
> this metadata).
>=20
> The mount-time whole checkpoint reversion, that is to say rollback,
> seems rather difficult than this.  In my estimation, it would take to=
o
> long time to rewrite whole DAT file.

thanks for prompt reply.

I'm surprised this is that complex. My limited understanding of NILFS2 =
was=20
that the latest complete checkpoint is considered `the current one' dur=
ing=20
mount. The big idea was to irreversibly destroy (by actually overwritti=
ng=20
relevant metadata) the checkpoints if admin indicated that wish with th=
e=20
supposed new `rollbackto=3D<checkpoint_number>' parameter. Just before =
the mount=20
operation; perhaps even going through the normal rountine for recovery =
after=20
unclean mount.

After that, the latest remaining checkpoint (the one indicated in optio=
n)=20
would be the current state of the FS. The metadata from that checkpoint=
 would=20
be used, and newer metadata from newer checkpoints would simply be=20
inaccessible to the driver. No new checkpoint would be created in that =
case,=20
unlike the action of `rmcp' command.

How far am I here from the actual workings of the filesystem?


meta: oops, sent reply directly to Ryusuke again. Sorry~


Regards
--
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
