From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH 7/7] rmcp: print sensible error message on permission
 failure
Date: Sat, 24 Dec 2011 16:20:41 +0900 (JST)
Message-ID: <20111224.162041.267403683.ryusuke@osrg.net>
References: <1324503249-17432-8-git-send-email-dan@archlinux.org>
	<20111223.145629.123971064.ryusuke@osrg.net>
	<CAEik5nNHs1Lp-Wz_p9k_Xt1-CBu4L=Agsf28vVC7iBp4mSsuwA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEik5nNHs1Lp-Wz_p9k_Xt1-CBu4L=Agsf28vVC7iBp4mSsuwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Dan,
On Fri, 23 Dec 2011 10:00:54 -0500, Dan McGee wrote:
> On Fri, Dec 23, 2011 at 12:56 AM, Ryusuke Konishi
> <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> > On Wed, 21 Dec 2011 15:34:09 -0600, Dan McGee wrote:
> >> When running as non-root, the error message seems to indicate a
> >> checkpoint is a snapshot, rather than the actual problem, which is=
 that
> >> I do not have permission to delete the checkpoints.
> >>
> >> Before:
> >> =A0 =A0 $ rmcp 29..35
> >> =A0 =A0 rmcp: 29: cannot remove snapshot
> >> =A0 =A0 rmcp: 30: cannot remove snapshot
> >> =A0 =A0 rmcp: 31: cannot remove snapshot
> >> =A0 =A0 rmcp: 32: cannot remove snapshot
> >> =A0 =A0 rmcp: 33: cannot remove snapshot
> >> =A0 =A0 rmcp: 34: cannot remove snapshot
> >> =A0 =A0 rmcp: 35: cannot remove snapshot
> >>
> >> =A0 =A0 To delete snapshot(s), change them into checkpoints with
> >> =A0 =A0 chcp command before removal.
> >>
> >> After:
> >> =A0 =A0 $ ./bin/rmcp 29..35
> >> =A0 =A0 lt-rmcp: 29: cannot remove checkpoint: Operation not permi=
tted
> >> =A0 =A0 lt-rmcp: 30: cannot remove checkpoint: Operation not permi=
tted
> >> =A0 =A0 lt-rmcp: 31: cannot remove checkpoint: Operation not permi=
tted
> >> =A0 =A0 lt-rmcp: 32: cannot remove checkpoint: Operation not permi=
tted
> >> =A0 =A0 lt-rmcp: 33: cannot remove checkpoint: Operation not permi=
tted
> >> =A0 =A0 lt-rmcp: 34: cannot remove checkpoint: Operation not permi=
tted
> >> =A0 =A0 lt-rmcp: 35: cannot remove checkpoint: Operation not permi=
tted
> >>
> >> Since May 2009 the kernel has returned EBUSY instead of EPERM for
> >> removal requests against snapshots, commit 30c25be71fcbd87fd. We s=
hould
> >> be able to treat EPERM as expected now, as the commit message ther=
e
> >> indicates.
> >>
> >> Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
> >> ---
> >>
> >> This does introduce a behavior change as well- we no longer exit t=
he range loop
> >> immediately on an error code, instead we continue the loop and att=
empt to
> >> delete the rest of the checkpoints in the range. Objections to thi=
s? I'm not an
> >> expert by any means.
> >>
> >> =A0bin/rmcp.c | =A0 10 ++++++----
> >> =A01 files changed, 6 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/bin/rmcp.c b/bin/rmcp.c
> >> index 780a192..3c5c184 100644
> >> --- a/bin/rmcp.c
> >> +++ b/bin/rmcp.c
> >> @@ -105,7 +105,7 @@ static int rmcp_remove_range(struct nilfs *nil=
fs,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nd++;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (errno =3D=3D EBUSY || errno =3D=3D E=
PERM) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (errno =3D=3D EBUSY) {
> >
> > OK, let's stop regarding the EPERM error as EBUSY. =A0For most kern=
els,
> > it's more important to distinguish real permission errors from the
> > snapshot removal error.
> >
> > We have only recently bumped the version of nilfs-utils to 2.1.x fr=
om
> > 2.0.x. =A0It's a good opportunity for this change.
> >
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nss++;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!force) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprint=
f(stderr,
> >> @@ -115,14 +115,16 @@ static int rmcp_remove_range(struct nilfs *n=
ilfs,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (errno =3D=3D ENOENT) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nocp++;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, "%s: %s\=
n", progname, strerror(errno));
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "%s: %ll=
u: cannot remove checkpoint: %s\n",
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 progname=
, (unsigned long long)cno,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strerror=
(errno));
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -1;
> >
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> >
> > Could you revise this ?
> >
> > I think the loop should abort immidiately when the rmcp meets an
> > important error even though it will change behavior for the real
> > permission error.
>=20
> 1. Please define "important"- is EPERM important? I would tend to say
> the error should be printed once per checkpoint as it is now in this
> case for EPERM, and then restore the prior behavior for other actions=
=2E

I meant something critical (e.g. ENOMEM, EIO) or violative (EPERM).

The original EPERM check was just a workaround for early nilfs
implementation, which returns EPERM when trying to remove checkpoints
in snapshot mode.

Now EPERM is returned only if the caller is not allowed to
remove/change checkpoints.

If the caller does not have proper right, every remove operation fails
and it never succeeds partially.  Although the result is predictable,
it may repeat thousands of the same error messages.

As for the critical errors, I think continuing operations is not
undesirable not to worsen the situation.


> 2. I'm not very fond of the error messages with the immediate exit:
>=20
>     $ ./bin/rmcp 100..105 115..125
>     lt-rmcp: 100: cannot remove checkpoint: Operation not permitted
>     $ echo $?
>     1
>=20
> Did 101-105 succeed? Did the second range succeed? Judging from this
> (lack of) output, I would think it did, which is quite obviously not
> the case.

Right.  It's ambiguous from the current messages.

How about printing an additional message to indicate the range of
unprocessed checkpoints if aborting the loop ?

  104: cannot remove checkpoint: xxxxx
  Checkpoints 104..105 115..125 were not removed.


With regards,
Ryusuke Konishi
=20
> So I would vote to not exit early in at least the semi-normal EPERM
> case; perhaps we do for the others. What is the reasoning behind
> exiting early in even the abnormal error cases?
>=20
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 }
> >> =A0 =A0 =A0 if (!force && (nss > 0 || (nocp > 0 && nd =3D=3D 0)))
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D 1;
> >> - out:
> >> +
> >> =A0 =A0 =A0 *ndeleted =3D nd;
> >> =A0 =A0 =A0 *nsnapshots =3D nss;
> >> =A0 =A0 =A0 return ret;
> >> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
