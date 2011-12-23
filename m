From: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Subject: Re: [PATCH 7/7] rmcp: print sensible error message on permission failure
Date: Fri, 23 Dec 2011 10:00:54 -0500
Message-ID: <CAEik5nNHs1Lp-Wz_p9k_Xt1-CBu4L=Agsf28vVC7iBp4mSsuwA@mail.gmail.com>
References: <1324503249-17432-1-git-send-email-dan@archlinux.org>
	<1324503249-17432-8-git-send-email-dan@archlinux.org>
	<20111223.145629.123971064.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=OghzfOoJBHL/ZdBSyuEr1SpKjQYk6Pb8Me/mmXlnEAM=;
        b=InrSNGSCzd8bY5XEEHowJfIUAHkYTCX/mBwZQHlPpekQs+Lp4wcxZmYL0UlNA3IGC+
         8XUVokW6RGUfV9PQIqe1+UaVJwCsO5lrkZ3c5svKfauRm/RezJjvBybx7pCJy+ZbAdoX
         ms7ivRJ/bzL+BvVDlSOnzuQzpu7vTRML/Cjpk=
In-Reply-To: <20111223.145629.123971064.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Dec 23, 2011 at 12:56 AM, Ryusuke Konishi
<konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> On Wed, 21 Dec 2011 15:34:09 -0600, Dan McGee wrote:
>> When running as non-root, the error message seems to indicate a
>> checkpoint is a snapshot, rather than the actual problem, which is t=
hat
>> I do not have permission to delete the checkpoints.
>>
>> Before:
>> =C2=A0 =C2=A0 $ rmcp 29..35
>> =C2=A0 =C2=A0 rmcp: 29: cannot remove snapshot
>> =C2=A0 =C2=A0 rmcp: 30: cannot remove snapshot
>> =C2=A0 =C2=A0 rmcp: 31: cannot remove snapshot
>> =C2=A0 =C2=A0 rmcp: 32: cannot remove snapshot
>> =C2=A0 =C2=A0 rmcp: 33: cannot remove snapshot
>> =C2=A0 =C2=A0 rmcp: 34: cannot remove snapshot
>> =C2=A0 =C2=A0 rmcp: 35: cannot remove snapshot
>>
>> =C2=A0 =C2=A0 To delete snapshot(s), change them into checkpoints wi=
th
>> =C2=A0 =C2=A0 chcp command before removal.
>>
>> After:
>> =C2=A0 =C2=A0 $ ./bin/rmcp 29..35
>> =C2=A0 =C2=A0 lt-rmcp: 29: cannot remove checkpoint: Operation not p=
ermitted
>> =C2=A0 =C2=A0 lt-rmcp: 30: cannot remove checkpoint: Operation not p=
ermitted
>> =C2=A0 =C2=A0 lt-rmcp: 31: cannot remove checkpoint: Operation not p=
ermitted
>> =C2=A0 =C2=A0 lt-rmcp: 32: cannot remove checkpoint: Operation not p=
ermitted
>> =C2=A0 =C2=A0 lt-rmcp: 33: cannot remove checkpoint: Operation not p=
ermitted
>> =C2=A0 =C2=A0 lt-rmcp: 34: cannot remove checkpoint: Operation not p=
ermitted
>> =C2=A0 =C2=A0 lt-rmcp: 35: cannot remove checkpoint: Operation not p=
ermitted
>>
>> Since May 2009 the kernel has returned EBUSY instead of EPERM for
>> removal requests against snapshots, commit 30c25be71fcbd87fd. We sho=
uld
>> be able to treat EPERM as expected now, as the commit message there
>> indicates.
>>
>> Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
>> ---
>>
>> This does introduce a behavior change as well- we no longer exit the=
 range loop
>> immediately on an error code, instead we continue the loop and attem=
pt to
>> delete the rest of the checkpoints in the range. Objections to this?=
 I'm not an
>> expert by any means.
>>
>> =C2=A0bin/rmcp.c | =C2=A0 10 ++++++----
>> =C2=A01 files changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/bin/rmcp.c b/bin/rmcp.c
>> index 780a192..3c5c184 100644
>> --- a/bin/rmcp.c
>> +++ b/bin/rmcp.c
>> @@ -105,7 +105,7 @@ static int rmcp_remove_range(struct nilfs *nilfs=
,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 nd++;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 continue;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (errno =3D=3D EBUSY |=
| errno =3D=3D EPERM) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (errno =3D=3D EBUSY) =
{
>
> OK, let's stop regarding the EPERM error as EBUSY. =C2=A0For most ker=
nels,
> it's more important to distinguish real permission errors from the
> snapshot removal error.
>
> We have only recently bumped the version of nilfs-utils to 2.1.x from
> 2.0.x. =C2=A0It's a good opportunity for this change.
>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 nss++;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (!force) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr,
>> @@ -115,14 +115,16 @@ static int rmcp_remove_range(struct nilfs *nil=
fs,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (errno =3D=
=3D ENOENT) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 nocp++;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 fprintf(stderr, "%s: %s\n", progname, strerror(errno));
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 fprintf(stderr,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "%s: %llu: cannot remove checkpoint: %s=
\n",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 progname, (unsigned long long)cno,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strerror(errno));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ret =3D -1;
>
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 goto out;
>
> Could you revise this ?
>
> I think the loop should abort immidiately when the rmcp meets an
> important error even though it will change behavior for the real
> permission error.

1. Please define "important"- is EPERM important? I would tend to say
the error should be printed once per checkpoint as it is now in this
case for EPERM, and then restore the prior behavior for other actions.
2. I'm not very fond of the error messages with the immediate exit:

    $ ./bin/rmcp 100..105 115..125
    lt-rmcp: 100: cannot remove checkpoint: Operation not permitted
    $ echo $?
    1

Did 101-105 succeed? Did the second range succeed? Judging from this
(lack of) output, I would think it did, which is quite obviously not
the case.

So I would vote to not exit early in at least the semi-normal EPERM
case; perhaps we do for the others. What is the reasoning behind
exiting early in even the abnormal error cases?

>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 if (!force && (nss > 0 || (nocp > 0 && nd =3D=3D=
 0)))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D 1;
>> - out:
>> +
>> =C2=A0 =C2=A0 =C2=A0 *ndeleted =3D nd;
>> =C2=A0 =C2=A0 =C2=A0 *nsnapshots =3D nss;
>> =C2=A0 =C2=A0 =C2=A0 return ret;
>> --
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
