From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: very large mount time after unxepected power down
Date: Wed, 28 Nov 2012 11:10:00 +0400
Message-ID: <1354086600.2122.41.camel@slavad-ubuntu>
References: <CAFPMYnE3ybWO4o=E1UonAZJ7Uwn5y9n4840ksYGAu7qAYJ0zKw@mail.gmail.com>
	 <CAFPMYnEZ28qvwkE3kaB59h2rD_8noT+gQtp7Hs6uvmHcL6KzYA@mail.gmail.com>
	 <1351604965.2069.13.camel@slavad-ubuntu>
	 <CAFPMYnHhtFxuVZOMu9MZ6Xb74mFPm1a-4axyFKkHiJjDEW_4BA@mail.gmail.com>
	 <1351608774.2026.6.camel@slavad-ubuntu>
	 <CAFPMYnGn4aNf=5B9v93TtTc6x4hG1ULgt0P9i75uO=xGX0U2bg@mail.gmail.com>
	 <AFFE5823-0AD0-488C-B465-55CF45A10785@dubeyko.com>
	 <CAFPMYnEtXMr1UOVYdNNRxxH83=O-_UOR_ZhCdqjh+JuUNrFiDA@mail.gmail.com>
	 <1351664002.2105.3.camel@slavad-ubuntu>
	 <CAFPMYnHyUSEr5jwBNkh43Xpt=VrzgiSCK8LG3Vkf3HcwV9cnMQ@mail.gmail.com>
	 <CAFPMYnHB=x2y3C-bVSEcaT2nMYn12zc5Jnr56ph31zBbym4Kfw@mail.gmail.com>
	 <CAFPMYnE2j0DjiqcSuJRiJX5hfDjHoyh-WUhG0cMav9K=tbsLDQ@mail.gmail.com>
	 <1352961172.2076.10.camel@slavad-ubuntu>
	 <CAFPMYnH4npNU8dJKAHwjatxAA=WoT10EWho5xyYjZJjz4uOYBA@mail.gmail.com>
	 <CAFPMYnG6zjT6-=x7XcVuuCp1__H0FhCBfNmyrfQi8dNpWC_m2w@mail.gmail.com>
	 <1353047197.2029.5.camel@slavad-ubuntu>
	 <CAFPMYnFLSZW068cFZ4FqDKF5sS_zF3SoV=vPG2=m+kvaxq-BZA@mail.gmail.com>
	 <1353048835.2029.17.camel@slavad-ubuntu>
	 <CAFPMYnEYnLv5e6a3ZcFRjw-8cNB80T5=mpuiX9jaWa+pEj8Q-A@mail.gmail.com>
	 <1353073969.9135.7.camel@slavad-ubuntu>
	 <CAFPMYnHAcy3u9D6UnNeUCUuiNfDG_1RccWk948JVMg75P_PFcg@mail.gmail.com>
	 <CAFPMYnHzghu8k36wQj5h4K7a2wS6EcURcQmCOUTb5B2CJB9ufQ@mail.gmail.com>
	 <782558C7-081D-4466-8780-51886E209A62@dubeyko.com>
	 <CAFPMYnGT1byuVA1hCnETWc2GZAbDsjeS95-F8f15QYPe_YHABA@mail.gmail.com>
	 <1354000375.2037.7.camel@slavad-ubuntu>
	 <CAFPMYnFTvQVTC7sgmq=9sx4hX7fKkXyjNHSRXay3yTuRQsOq4w@mail.gmail.com>
	 <1354003110.2037.14.camel@slavad-ubuntu>
	 <CAFPMYnEPJLQs9TVMy8PFXqV-XvsM8oTvrf_XTE0+g9cQ+5MJXA@mail.gmail.com>
	 <CAFPMYnFKKwfRD6zpO_AYCMXP5U_deHfOF6CXGdd6jjMjVkMJ6w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=eAhzbHBQ88d/dQ46XpXgtylo2SpmAlQsaYWqnxPoLSQ=;
	b=Q1MhBGX/1j+FdO2BWlJg3FQGcbm3w8e+UCKbKDX+u1V297uyBomgqeC4JUad+coN4kcTOIrdw3r0teuyFSdzZw0IdOLhFLflT/CAc2nAY8YLiJaZdIrolqPMz9ntjWOq;
In-Reply-To: <CAFPMYnFKKwfRD6zpO_AYCMXP5U_deHfOF6CXGdd6jjMjVkMJ6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9_?= =?UTF-8?Q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE?= =?UTF-8?Q?=D0=B2?= <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Tue, 2012-11-27 at 12:58 +0300, =D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9=
 =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 wro=
te:
> As I expected, no new info:
> [57291.417113] NILFS warning: mounting unchecked fs
> [57291.417125] NILFS: nilfs_search_super_root
> [57291.417132] NILFS: pseg_start 115603456, seg_seq 4347757
> [57291.417137] NILFS: cno 1252241, segnum 56447
> [62768.349242] NILFS: recovery complete.
> [62768.351804] segctord starting. Construction interval =3D 5 seconds=
,
> CP frequency < 30 seconds
>=20
> So, I suppose, nilfs is searching for a super root for a very long
> time and find's out that it is consistent.

Currently, I have such picture of the issue's nature. The key details
are: (1) long system uptime; (2) sudden power-off; (3) special case of
interrelation of s_last_pseg fields in primary and secondary
superblocks. This combination of factors leads to the situation when th=
e
issue takes place.

The NILFS2 volume has two superblocks (primary and secondary). Only one
superblock is active after filesystem mount and to keep actual
superblock state. Another superblock keeps previous superblock's state
and previous value of s_last_pseg field. When it is detected an invalid
state of log for the value of s_last_pseg in actual superblock then it
makes trying to search a previous valid supper root block. If we have
previous value of s_last_pseg in another superblock then it is possible
to find previous valid super root by means of passing through the chain
of log starting from the s_last_pseg of backup superblock. Usually, all
works fine for the case when the s_last_pseg field in actual superblock
is greater than s_last_pseg field in backup superblock. So, if we have
other situation (s_last_pseg field of actual superblock is lesser than
s_last_pseg field of backup superblock) then it needs to pass through
logs' chain from the end of volume to the volume begin. Such logic
results in the issue only when we have s_last_pseg field of actual
superblock is lesser than s_last_pseg field of backup superblock and a
slightly small difference in values. So, for the case if s_last_pseg of
actual superblock has 115603456 and s_last_pseg of backup superblock ha=
s
160163840 values then we need to passing through the whole volume
starting from the end.

I think that a proper fix of the issue is to make periodic flushing of
backup superblock in the case of long system uptime with the purpose to
have reasonable difference between of s_last_pseg field of actual
superblock and s_last_pseg field of backup superblock. I am going to fi=
x
the issue in such way.

With the best regards,
Vyacheslav Dubeyko.

> --------------------------------------------------
> =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2 =D0=
=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9 =D0=92=D0=B0=D1=81=D0=B8=D0=BB=D1=8C=D0=
=B5=D0=B2=D0=B8=D1=87
>=20
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
