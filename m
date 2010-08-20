From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: FYI: User land tools status
Date: Fri, 20 Aug 2010 09:00:54 -0400
Message-ID: <AANLkTinxxrNsO-s3H3sQ=h3+GSyJY-hF5RKWqT1mX3ax@mail.gmail.com>
References: <87zkwhx55n.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:received:in-reply-to
         :references:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        bh=9ewAeOZ3qguyStStC8bOb6s7bSnWBzFAXaURgUjEMDk=;
        b=cUJuA9WloAASrQCQuwXy5NNG8zF9s3o+A8h7S2xiuRt+uUVpp/t4fa4k43gNEYeMuL
         t9Sqp+C1/+Up+t85+1ZFeVQFXmJNIRVVVUvUGZelBWuFxOHJmTcgh129q62J71GX+RbG
         CmDbRiPOoaBUOEtvcMlVNgMHC9oykacDeqdgk=
In-Reply-To: <87zkwhx55n.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

=46inally, blkid support! Very nice for initramfs scripts. It would be
nice if the TODO for unified nilfs2 management tool gets completed,
just like btrfs did with the btrfs command, very useful for someone
new to the FS, all commands are listed with online help and boot
scripts will finally be able to settle on specific commands.

On Fri, Aug 20, 2010 at 12:46 AM, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
>
> Hi,
>
> I'm pleased to share the status of the user land tools I've been work=
ing on.
> Recently a few patches are incorporated into util-linux-ng and udisks
> to support NILFS. =A0With those changes, you can play with NILFS more
> convenient manner now.
>
> New blkid in util-linux-ng let you mount NILFS partition with volume =
label
> or UUID instead of device file, just like other filesystem does.
>
> Furthermore you can use palimpsest to create, mount, umount the NILFS
> partition by new udisks(aka DeviceKit-disks).
>
> palimpsest is a graphical tool to manage drives and media of
> gnome-disk-utility project used in ubuntu.
>
> I don't see any Distro updates to support those yet, but at least
> you can try those by retrieving source code repository of those proje=
cts.
>
> util-linux-ng:
> =A0git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git
> udisks:
> =A0git://git.freedesktop.org/git/DeviceKit/DeviceKit-disks.git
>
> You need recent util-linux-ng and nilfs2-utils to try the new udisks.
>
> I also working on GNU parted to support NILFS. =A0The patch is alread=
y
> in public, but need some more "paper work" for code assignment.
> http://lists.alioth.debian.org/pipermail/parted-devel/2010-July/00371=
5.html
>
> Any feedbacks, comments, requests for those utilities/patches are wel=
come!
>
> Thanks,
>
> Regards,
> --
> Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
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
