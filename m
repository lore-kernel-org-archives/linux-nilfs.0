From: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Removed checkpoints are still subject to protection period
Date: Wed, 22 Jun 2011 12:59:40 +0200
Message-ID: <201106221259.40135.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:from:to:subject:date:user-agent:x-face
         :mime-version:content-type:content-transfer-encoding:message-id;
        bh=KkrUkkPSoYYWwbkpKNbggrVWIzRVOtUDN0MYT5nKSCA=;
        b=Nb0nzCWl2t/gEVdGJl9j0TgXC6zGAfFvjGz5dega9G7ERAf94rYkVZT+hpWjwMA3S8
         3+bLdYgN9iy2cZoS86IFXiInvhqx/KyMKwzz/EwAXE4/UI7fRMB0ppJ3rOrP+exH6aae
         Eh6W55cx7YMcWmx1urjGhx3X9dWRFdNkZavgw=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,


steps to reproduce:
 * create empty filesystem, mount, ensure nilfs_cleanerd is running on =
it
 * configure the nilfs_cleanerd for protection period 3600 (seconds)
 * create a bunch of files
 * delete the files
 * the nilfs_cleanerd does not reclaim space, because checkpoints are p=
rotected for 3600 seconds (the expected behavior)
 * remove all the snapshots with rmcp
 * the problem: the nilfs_cleanerd still does not reclaim space -- it c=
onsiders the deleted checkpoints as still protected for the duration of=
 3600 seconds
 * once 3600 seconds passes, nilfs_cleanerd normally reclaims space

Expected behavior: cleanerd reclaims diskspace of deleted checkpoints r=
egardless of protection period.
Rationale: there's no user-visible way of accessing deleted checkpoints=
, so there is no point in keeping them 'round.


tested with linux v3.0-rc4, nilfs-utils v2.0.23


Regards,
--=20
dexen deVries

[[[=E2=86=93][=E2=86=92]]]

=46or example, if the first thing in the file is:
   <?kzy irefvba=3D"1.0" rapbqvat=3D"ebg13"?>
an XML parser will recognize that the document is stored in the traditi=
onal ROT13 encoding.

(( Joe English, http://www.flightlab.com/~joe/sgml/faq-not.txt ))
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
