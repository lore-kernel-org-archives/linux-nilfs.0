From: Andrea Gelmini <andrea.gelmini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nilfs_btree_propagate problem
Date: Thu, 7 Oct 2010 15:23:45 +0200
Message-ID: <AANLkTinw3anEyeWf95krAt5SH45RaaE6iCm-LU5Egj=1@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:received:date:message-id
         :subject:from:to:content-type:content-transfer-encoding;
        bh=/Qw9gH60ke8VjhCZQKmLt4HfkLUUNrQNzxBU1bylxOw=;
        b=tNPbTl1IRftcY+MsUhqLtv/4lZHhO5LyAMZvSXZqJPPnZKxMA3OBXyVH5QZPhQ3hfi
         Ng8XSRzGCclDol01andy3g4V2yjnqt0LdNnzYVdNC70nlJPZh7MchfxhcBkM9s44wmMs
         nIuouzxnVfuSOYSjhv3Fn0pyEIUq5TWvqMlP0=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="tis-620"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,
  and thanks a lot for your work on Nilfs.
  I'm using it for my /home, with
  Ubuntu 10.10
  Vanilla kernel from Linus git repository (at this commit)=C2=B9
  nilfs_cleanerd v2.0.18 (from ubuntu deb nilfs-tools 2.0.18-2).

  Well, everything's working fine, but since the initial clone of my
data, I have problem
  with ~/dev/prg/wine.
  I mean, if I try to compile it, after a while, I had process stucked
(it seems they are not
  able to write, but they can read from the disk).
  Meanwhile my log are flooded with this:
Oct  7 11:53:39 vaio kernel: [ 3408.688565] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:53:44 vaio kernel: [ 3413.696833] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:53:49 vaio kernel: [ 3418.704543] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:53:54 vaio kernel: [ 3423.712541] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:53:59 vaio kernel: [ 3428.720545] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:54:04 vaio kernel: [ 3433.728548] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:54:09 vaio kernel: [ 3438.736543] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:54:14 vaio kernel: [ 3443.744543] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:54:19 vaio kernel: [ 3448.752543] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:54:24 vaio kernel: [ 3453.760542] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:54:29 vaio kernel: [ 3458.768554] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:54:34 vaio kernel: [ 3463.776543] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:54:39 vaio kernel: [ 3468.784458] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:54:44 vaio kernel: [ 3473.792545] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:54:49 vaio kernel: [ 3478.800543] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:54:54 vaio kernel: [ 3483.808542] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:54:59 vaio kernel: [ 3488.816546] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:55:04 vaio kernel: [ 3493.824543] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:55:09 vaio kernel: [ 3498.832545] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0
Oct  7 11:55:14 vaio kernel: [ 3503.840554] nilfs_btree_propagate: key
=3D 2823, level =3D=3D 0

   I guess it's important to note the 5 seconds of delay between log
entries. Yes, it's my
   snapshot interval.
   The only way to solve it is a crude switch off/on.
   At reboot everything is looking fine.

   Reading access gives no problems:
    find -type f  -exec cat {} > /dev/null \;

Any clues?

Thanks a lot for your time and work,
Andrea

n.b.: well, I almost use my notebook with hibernation/resume. Does
nilfs_cleanerd suffer long jumps in time? Also, sometimes
        the resume doesn't go well. I force a sync before hibernation,
but does the fs can be screwed in this way?


---------------------------
=C2=B9 http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.g=
it;a=3Dcommit;h=3D7c6d45e665d5322401e4439060bbf758b08422d4
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
