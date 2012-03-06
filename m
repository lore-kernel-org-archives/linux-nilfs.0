From: Slicky Devil <slicky.dvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 00000048
Date: Tue, 6 Mar 2012 16:24:40 +0300
Message-ID: <CAMRzUtwpZQ_ZmZoGzOA0wkmTVQKVJRwA7OB3X_ktRXPj9MJoXA@mail.gmail.com>
References: <CAMRzUtxbOXWOyZ1wMRmxSsRs67FoDq_hf7Pg_UrAi4P=DnhqsA@mail.gmail.com>
	<20120305.233028.248350005.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=VSd5S1hqFOCULpX1It4meoLCFGPruWMWSEfE4DfemU8=;
        b=JYo4FBc3soHI+s49G/lhjGP2rscmDtAmgNvTfecWF4hzdUdR1pXQuzJ8eQg1ovmWCc
         ryf9rSKColbr6mTPV792B/Cnwatbyij+iXjHAPcvf9yYcj7pzjdhiMc5ZsnmWmKMYxgx
         qwInZd1k5ckACWoPGq/3MdZ4YL40RSsTqr1Jmfna2MmMMA18vBMoxegBzkieHHJt7lbx
         UNqCIGKzeLzx1eVO9ZDuZEtvKq9YqIBmzUXkuqAkp1210jRfO5GtXWQTa1MIIHrMt/ah
         bl/+C6rVH+Rl6pAQXBP+erJdCEuj7zurgc619TB4ljP/fR0ImRjlFtlq+1Rc8a3NeHtt
         XbIA==
In-Reply-To: <20120305.233028.248350005.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Luckily, I seem to have been able to reproduce the bug (after
shrinking the partition down to some hundred MB). Your patch seems to
have fixed it!

Now I get the following, which, I think, is pretty much expected,
since I chopped a large part of the filesystem off:

15:52 root ~ # mount /dev/1/buggy-home test
[  461.137823] NILFS: error searching super root.
mount.nilfs2: Error while mounting /dev/mapper/1-buggy--home on
/root/test: Input/output error

Please, fix the bug in the official kernel sources, too. Your
filesystem proved very useful here for storing documents and other
changeable stuff -- we don't want it get broken unexpectedly. :)

Still, thanks a lot! The things you are doing here are really cool!

Cheers!



On Mon, Mar 5, 2012 at 5:30 PM, Ryusuke Konishi
<konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
>
> Thank you for reporting this issue.
>
> I found a bug in the nilfs_load_super_block function which has
> potential to cause this oops.
>
> Could you try the following patch if you still have the partition ?
>
>
> Thanks,
> Ryusuke Konishi
>
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index d327140..35a8970 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -515,6 +515,7 @@ static int nilfs_load_super_block(struct the_nilf=
s *nilfs,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0brelse(sbh[1]);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sbh[1] =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sbp[1] =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 valid[1] =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0swp =3D 0;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0if (!valid[swp]) {
> --
> 1.7.7.4
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
